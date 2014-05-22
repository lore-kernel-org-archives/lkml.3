Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730AbaEVMdE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 08:33:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:45220 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875AbaEVMdC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 08:33:02 -0400
Date: Thu, 22 May 2014 14:32:51 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Borislav Petkov <bp@alien8.de>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Ingo Molnar <mingo@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "ego@linux.vnet.ibm.com" <ego@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] intel_rapl: Correct hotplug correction
Message-ID: <20140522123251.GU30445@twins.programming.kicks-ass.net>
References: <1400750624-19238-1-git-send-email-bp@alien8.de>
 <537DC6D2.8040305@linux.vnet.ibm.com>
 <20140522100820.GE4383@pd.tnic>
 <537DE579.6000505@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="K/BmBeHUK5PA/HQO"
Content-Disposition: inline
In-Reply-To: <537DE579.6000505@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--K/BmBeHUK5PA/HQO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 22, 2014 at 05:24:33PM +0530, Srivatsa S. Bhat wrote:
> Yeah, its complicated and perhaps we can do much better than that. But I'=
ll
> try to explain why there are so many different locks in the existing code.
>=20
> get/put_online_cpus() uses cpu_hotplug.lock underneath. Although that's j=
ust
> a mutex, its not used in the usual way (more about that below).
>=20
> cpu_maps_update_begin(), cpu_notifier_register_begin/done,
> register/unregister_cpu_notifier  -- all of these use the cpu_add_remove_=
lock.
>=20
> The fundamental difference between these 2 categories is the concurrency
> allowed with the lock :-
> get_online_cpus() is like a read_lock(). That is, it allows any number
> of concurrent CPU hotplug readers (tasks that want to block hotplug), but=
 it
> ensures that a writer won't run concurrently with any reader.
>=20
> Hence, this won't work for notifier registrations because register/unregi=
ster
> has to _mutate_ the notifier linked-list, and obviously we can't have mul=
tiple
> tasks trying to do this at the same time. So we need a proper mutex that
> allows only 1 task at a time into the critical section. That's why the
> cpu_add_remove_lock is used in all the register/unregister paths.
>=20
> Now, let's look at why the CPU hotplug writer path (the task that actually
> does hotplug) takes cpu_add_remove_lock in addition to the cpu_hotplug.lo=
ck.
> First reason is simple: you don't want tasks that are doing notifier
> [un]registrations to race with hotplug. But the second, although subtle r=
eason
> is that put_online_cpus() and cpu_hotplug_writer_begin()/done() require t=
hat
> there is only 1 CPU hotplug writer at a time. The cpu_add_remove_lock pro=
vides
> this guarantee, since it is taken in the writer path. (The long comment a=
bove
> cpu_hotplug_begin() mentions this as well).
>=20
> And then there is powerpc which uses cpu_maps_update_begin/done() to prot=
ect
> dlpar operations (operations that change the cpu_present_mask etc). But i=
deally
> it should have just used cpu_hotplug_begin() itself, like what driver/acp=
i/
> processor_driver.c does, but then it would have to hold cpu_add_remove_lo=
ck
> as well, due to the current design :(
>=20
> That was just me trying to explain the current mess, not justifying it! :=
-/

So I think we can reduce it to just the one rwsem (with recursion) if we
shoot CPU_POST_DEAD in the head.

Because currently we cannot take the rwsem in exclusive mode over the
whole thing because of POST_DEAD.

Once we kill that, the hotplug lock's exclusive mode can cover the
entire hotplug operation.

For (un)registrer we can also use the exclusive lock, (un)register of
notifiers should not happen often and should equally not be performance
critical, so using the exclusive lock should be just fine.

That means we can then remove cpu_add_remove_lock from both the register
and hotplug ops proper. (un)register_cpu_notifier() should get an
assertion that we hold the hotplug lock in exclusive mode.

That leaves the non-exclusive lock to guard against hotplug happening.

Now, last time Linus said he would like that to be a non-lock, and have
it weakly serialized, RCU style. Not sure we can fully pull that off,
haven't throught that through yet.

> I think Oleg had a proposed patch to use per-cpu rwsem in CPU hotplug to
> drastically simplify this whole locking scheme. I think we could look at
> that again.

I don't think that was to simplify things, the hotplug lock is basically
an open coded rw lock already, so that was to make it reuse the per-cpu
rwsem code.

--K/BmBeHUK5PA/HQO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTfe5zAAoJEHZH4aRLwOS6kSYP/AkFRCaussLoVy6PY7MgWh1V
JRk5jSvHNtujleNWI09noOkiLFOUqoduyl7MW6KCIpjjchbdkxmYxyXlFiRVYuLP
+jsNIf9xW+uzX9+njI9oi/uOH6Rj3c3s5AWdPIgeuKg8mHdFMFBu+y04GeRJvT4g
4VYoiYa/2F3V/wUCErCTCcD+v/0J8dKU0WymsdF+m0WDxUZhX7zklziSZDfu//2R
esAFTv5Q5r/6y+k3NIyCfOF+Bq6Y03rfFYjjiNuQqXHTG5ZyAJAYXmC0/jmfJkQu
5Bn8VlmNF45jyNf/e1RrvSyyshS2AjlBi19lY0g2GRL6DWY/3McSAUJmXIQagKTD
H/mE5DhS/Wj1lwnSVV/gCoQjTXiEPH6Sn3x+5rNFcHWrKMOcvb3qIE8ySnsgKuDN
NSNnOkn3weA3go30ikpINRQ1ogcGKJtoeynNTTgY/IbAQkEk9T5W+GCk6XHCZrzP
yL3UkfJvfFKCpGdNhVhMFpIyCvr2sPbMK0bQnAq0fH9khoXa7saJ5FrHeOze0Gkf
Y8B6Pw2GGCwCXfQVg0rRX5nomU3px7IqyahXVreUGfi50TYsxMWf/YT40mkHxTpN
AKHKqzcO+c0qnRwYTyh49j28wzKYb9IeXHH017ZxA9c2h+Y5F+Oq1yAMLjdLEPjE
ABo+ikXz15wudG+iGgG2
=VA3D
-----END PGP SIGNATURE-----

--K/BmBeHUK5PA/HQO--
