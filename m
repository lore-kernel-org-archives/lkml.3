Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517AbaBMRAt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 12:00:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53784 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbaBMRAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 12:00:48 -0500
Message-ID: <52FCFA23.4060701@canonical.com>
Date: Thu, 13 Feb 2014 18:00:19 +0100
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Borislav Petkov <bp@alien8.de>, Paolo Bonzini <pbonzini@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        MASAO TAKAHASHI <masao-takahashi@kanno.co.jp>,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: Another preempt folding issue?
References: <52FA6D4B.7020709@canonical.com> <20140211194553.GZ9987@twins.programming.kicks-ass.net> <52FB2EC8.4080602@canonical.com> <20140212103713.GE3545@laptop.programming.kicks-ass.net> <20140212104017.GA5121@pd.tnic> <52FB5669.7090506@canonical.com> <20140212115412.GW27965@twins.programming.kicks-ass.net>
In-Reply-To: <20140212115412.GW27965@twins.programming.kicks-ass.net>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="U3Q7gDoD1Dm5ktrann9qFgg69dsH44EF1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--U3Q7gDoD1Dm5ktrann9qFgg69dsH44EF1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 12.02.2014 12:54, Peter Zijlstra wrote:
> On Wed, Feb 12, 2014 at 12:09:29PM +0100, Stefan Bader wrote:
>> Something else here I run a kernel with CONFIG_PREEMPT not set and NR_=
CPUS
>> limited to 8 (for the 32bit kernel). So the default apic driver is use=
d. Since
>> default_send_IPI_mask_logical is only used from there, I assume the tr=
ace you
>> got does the same. Maybe something there is wrong which would explain =
why we
>> only see it on 32bit hosts.
>=20
> Can you try with a different APIC driver to test this?
>=20
I don't think I can. And I think the statement about this only be used fo=
r 32bit
could be wrong. I got mislead to think so because those are only defined =
in
probe_32 but the 64bit counterpart isn't containing much aside that.

Anyway, I played around with tracing a bit more. So with this change:

                if (need_resched()) {
                        srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
                        if (need_resched() !=3D should_resched()) {
+                               trace_printk("need(%i) !=3D should(%i)\n"=
,
+                                       need_resched(), should_resched())=
;
+                               trace_printk("exit_reason=3D%u\n",
+                                       vcpu->run->exit_reason);
+                                trace_printk("preempt_count=3D%lx\n",
+                                        __this_cpu_read_4(__preempt_coun=
t));
+                                tracing_stop();
+                                printk(KERN_ERR "Stopped tracing, due to=

inconsistent state.\n");
                        }
 +                      schedule();
 -                      cond_reschedule();
                        vcpu->srcu_idx =3D srcu_read_lock(&kvm->srcu);
                }

I get the following (weird) output:

            Xorg-1078  [001] d...    71.270251: native_smp_send_reschedul=
e
<-resched_task
            Xorg-1078  [001] d...    71.270251: default_send_IPI_mask_log=
ical
<-native_smp_send_reschedule
      bamfdaemon-2318  [001] d...    71.270465: resched_task <-check_pree=
mpt_wakeup
      bamfdaemon-2318  [001] d...    71.270539: resched_task <-check_pree=
mpt_wakeup
          compiz-2365  [001] d...    71.270689: resched_task <-check_pree=
mpt_wakeup
          compiz-2365  [001] d...    71.270827: resched_task <-check_pree=
mpt_wakeup
          compiz-2365  [001] d...    71.270940: resched_task <-check_pree=
mpt_wakeup
 qemu-system-x86-2679  [000] dn..    71.270999: smp_reschedule_interrupt
<-reschedule_interrupt
 qemu-system-x86-2679  [000] dn..    71.270999: scheduler_ipi
<-smp_reschedule_interrupt
 qemu-system-x86-2679  [000] .N..    71.271001: kvm_arch_vcpu_ioctl_run: =
need(1)
!=3D should(0)
 qemu-system-x86-2679  [000] .N..    71.271002: kvm_arch_vcpu_ioctl_run:
exit_reason=3D2
 qemu-system-x86-2679  [000] .N..    71.271003: kvm_arch_vcpu_ioctl_run:
preempt_count=3D0

So am I reading this right, that the interrupt did get delivered to cpu#0=
 while
the thread info already had the resched flag set. So this really should h=
ave
cleared the bit in preempt_count. But while the trace info shows 'N' for =
some
reason should_reschedule returns false but at the same time reading the p=
reempt
count manually shows it 0?



--U3Q7gDoD1Dm5ktrann9qFgg69dsH44EF1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCgAGBQJS/PojAAoJEOhnXe7L7s6j3xkQAImlBd6p2Q8Q5Wjf1otvjVdN
Hnj4NLY8EEc1zHi5IeQ+1pPLMNcaOMWT4blRiqNGMzGEeX8+XFKfzaxY/UtMui1t
v7QPAD9TTh6Prp87yK9Qeq79UhaxkElZG7ZuVb7DBGzRyPDFiNaj4XsyBaU9cDS+
FsCxhUBAKYqsjZSd5Tj4/Hmq/SjtobepPK+rBVOPndj4eqWiRH3Q31GXsVNqfKeE
lYhgs490RuKOBMPjguLBnslZV3rhKy+ZWx6jOVNAa2WXQtIIgaGMtyaRgfohM2NL
NuJ/1MbE9gjMfQlB/j4t6rsbr3snhb5zpLKkqllkeMrGl2V+gyzBu+nI9Fgu2bUP
2A7CpSBwZOlNo2Aw3BvpTkkLLJituQrQFIdgvD+2XQ1v7e9agccQqp7Pfu/QfPMn
6SMApp36ayFTAAvIFRocNGClsjQTwHzgVi24wNTp19yoMYGcIDIURbaPcJPH0heT
HoyvTz7UMomouOKLGA+X516xEdlsxHk7v+F+LByHusbQhSeRpjySEhHR7NOLqnZ1
A8YqmL3KTaG/iLXjlEtA3mDFD6IVHZ6RrRUtI+GHuyTnrFufQj6C0jcQRU8P++/L
9fb6nJdzHfPh1htk4GH1/tYt6+Nm46xGIm0+Yzv/WRZOiC4Q/HvYRhJXc6eF5pYM
F8oQsdLWBrEZy9HF2amE
=QD7P
-----END PGP SIGNATURE-----

--U3Q7gDoD1Dm5ktrann9qFgg69dsH44EF1--
