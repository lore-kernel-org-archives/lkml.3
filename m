Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655AbaBLIUf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:20:35 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44690 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256AbaBLIUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:20:33 -0500
Message-ID: <52FB2EC8.4080602@canonical.com>
Date: Wed, 12 Feb 2014 09:20:24 +0100
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Paolo Bonzini <pbonzini@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        MASAO TAKAHASHI <masao-takahashi@kanno.co.jp>,
        Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>
Subject: Re: Another preempt folding issue?
References: <52FA6D4B.7020709@canonical.com> <20140211194553.GZ9987@twins.programming.kicks-ass.net>
In-Reply-To: <20140211194553.GZ9987@twins.programming.kicks-ass.net>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="fpuUAXpUFRw9iq1UbHeRI4GTBQnHn9X10"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--fpuUAXpUFRw9iq1UbHeRI4GTBQnHn9X10
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 11.02.2014 20:45, Peter Zijlstra wrote:
> On Tue, Feb 11, 2014 at 07:34:51PM +0100, Stefan Bader wrote:
>> Hi Peter,
>>
>> I am currently looking at a weird issue that manifest itself when tryi=
ng to run
>> kvm enabled qemu on a i386 host (v3.13 kernel, oh and potentially impo=
rtant the
>> cpu is 64bit capable, so qemu-system-x86_64 is called).=20
>=20
> AMD or Intel machine?

Personally I am reproducing this on an AMD:

cpu family	: 15
model		: 72
model name	: AMD Turion(tm) 64 X2 Mobile Technology TL-64

but the reports I got are showing the same issue on an Intel i7

cpu family	: 6
model		: 37
model name	: Intel(R) Core(TM) i7 CPU       M 620  @ 2.67GH

Another reporter also saw this on an AMD and said it could not be reprodu=
ced on
the same hardware and the same software versions when using 64bit instead=
 of 32.

In my case on a 32bit installation I will see this on every invocation of=


qemu-system-x86_64 -cdrom <32bit live iso> -boot d -m 512

>=20
>> Sooner or later this
>> causes softlockup messages on the host. I tracked this down to __vcpu_=
run in
>> arch/x86/kvm/x86.c which does a loop which in that case never seems to=
 make
>> progress or exit.
>>
>> What I found is that vcpu_enter_guest will exit quickly without causin=
g the loop
>> to exit when need_resched() is true. Looking at a crash dump I took, t=
his was
>> the case (thread_info->flags had TIF_NEED_RESCHED set). So after immed=
iately
>> returning __vcpu_run has the following code:
>>
>>         if (need_resched()) {
>>                 srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
>>                 kvm_resched(vcpu); // now cond_resched();
>>                 vcpu->srcu_idx =3D srcu_read_lock(&kvm->srcu);
>>         }
>>
>> The kvm_resched basically would end up doing a cond_resched() which no=
w checks
>> preempt_count() to be 0. If that is zero it will do the reschedule, ot=
herwise it
>> just does nothing. Looking at the percpu variables in the dump, I saw =
that
>> the preempt_count was 0x8000000 (actually it was 0x80110000 but that w=
as me
>> triggering the kexec crashdump with sysrq-c).
>>
>> I saw that there have been some changes in the upstream kernel and hav=
e picked
>> the following:
>> 1) x86, acpi, idle: Restructure the mwait idle routines
>> 2) x86, idle: Use static_cpu_has() for CLFLUSH workaround, add barrier=
s
>> 3) sched/preempt: Fix up missed PREEMPT_NEED_RESCHED folding
>> 4) sched/preempt/x86: Fix voluntary preempt for x86
>>
>> Patch 1) and 2) as dependencies of 3) (to get the mwait function corre=
ct and to
>> the other file). Finally 4) is fixing up 3). [maybe worth suggesting t=
o do for
>> 3.13.y stable].
>>
>> Still, with all those I got the softlockup. Since I knew from the dump=
 info that
>> something is wrong with the folding, I made the pragmatic approach and=
 added the
>> following:
>>
>>         if (need_resched()) {
>>                 srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
>> +               preempt_fold_need_resched();
>>                 kvm_resched(vcpu); // now cond_resched();
>>                 vcpu->srcu_idx =3D srcu_read_lock(&kvm->srcu);
>>         }
>>
>> And this lets the kvm guest run without the softlockups! However I am =
less than
>> convinced that this is the right thing to do. Somehow something done w=
hen
>> converting the preempt_count into percpu has caused at least the i386 =
side to
>> get into this mess (as there has not been any whining about 64bit). Ju=
st fail to
>> see what.
>=20
> I've been looking at the same thing too; I've got a trace from someone
> who can reproduce and its just not making sense.
>=20
> Looks like the hardware is loosing an interrupt (or worse).
>=20
> With the below patch on top of current -git (might be whitespace damage=
d
> due to copy-paste).
>=20
> ---
>  arch/x86/kvm/x86.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 39c28f09dfd5..f8b2fc7ce491 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -6115,7 +6115,11 @@ static int __vcpu_run(struct kvm_vcpu *vcpu)
>                 }
>                 if (need_resched()) {
>                         srcu_read_unlock(&kvm->srcu, vcpu->srcu_idx);
> -                       cond_resched();
> +                       if (need_resched() !=3D should_resched()) {
> +                               tracing_stop();
> +                               printk(KERN_ERR "Stopped tracing, due t=
o inconsistent state.\n");
> +                       }
> +                       schedule();
>                         vcpu->srcu_idx =3D srcu_read_lock(&kvm->srcu);
>                 }
>         }
>=20
> ---
>=20
> I got the following from an Athlon X2 (fam 0xf):
>=20
> On Mon, Feb 10, 2014 at 05:23:15PM -0200, Marcelo Tosatti wrote:
>> What is the problem exactly?
>=20
> From the trace:
>=20
>  qemu-system-x86-2455  [001] d.s3   393.630586: smp_reschedule_interrup=
t <-reschedule_interrupt
>  qemu-system-x86-2455  [001] d.s3   393.630586: scheduler_ipi <-smp_res=
chedule_interrupt
>  qemu-system-x86-2455  [001] ..s3   393.630586: preempt_count_sub <-_ra=
w_spin_unlock_irqrestore
>  qemu-system-x86-2455  [001] ..s2   393.630586: _raw_spin_lock_irq <-ru=
n_timer_softirq
>  qemu-system-x86-2455  [001] d.s2   393.630586: preempt_count_add <-_ra=
w_spin_lock_irq
>  qemu-system-x86-2455  [001] d.s3   393.630586: _raw_spin_unlock_irq <-=
run_timer_softirq
>  qemu-system-x86-2455  [001] ..s3   393.630586: preempt_count_sub <-_ra=
w_spin_unlock_irq
>  qemu-system-x86-2455  [001] ..s2   393.630586: rcu_bh_qs <-__do_softir=
q
>  qemu-system-x86-2455  [001] d.s2   393.630586: irqtime_account_irq <-_=
_do_softirq
>  qemu-system-x86-2455  [001] d.s2   393.630586: __local_bh_enable <-__d=
o_softirq
>  qemu-system-x86-2455  [001] d.s2   393.630586: preempt_count_sub <-__l=
ocal_bh_enable
>=20
>=20
>            dmesg-2458  [000] d.s5   393.630614: resched_task <-check_pr=
eempt_wakeup
>            dmesg-2458  [000] d.s5   393.630614: native_smp_send_resched=
ule <-resched_task
>            dmesg-2458  [000] d.s5   393.630614: default_send_IPI_mask_l=
ogical <-native_smp_send_reschedule
>=20
>=20
>  qemu-system-x86-2455  [001] .n..   393.630636: preempt_count_add <-kma=
p_atomic_prot
>  qemu-system-x86-2455  [001] .n.1   393.630639: __kunmap_atomic <-clear=
_huge_page
>  qemu-system-x86-2455  [001] .n.1   393.630639: preempt_count_sub <-__k=
unmap_atomic
>  qemu-system-x86-2455  [001] .n..   393.630639: _cond_resched <-clear_h=
uge_page
>  qemu-system-x86-2455  [001] .n..   393.630640: kmap_atomic <-clear_hug=
e_page
>  qemu-system-x86-2455  [001] .n..   393.630640: kmap_atomic_prot <-kmap=
_atomic
>  qemu-system-x86-2455  [001] .n..   393.630640: preempt_count_add <-kma=
p_atomic_prot
>=20
>=20
> The resched_task() in the middle does:
>=20
>   set_tsk_need_resched();
>   smp_mb();
>   smp_send_reschedule();
>=20
> This means that the remote cpu must observe TIF_NEED_RESCHED (.n.. in
> the traces) when the IPI (smp_reschedule_interrupt) hits.
>=20
> Now given the machine has unsynchronized TSC the order in the above is
> not necessarily the true order, but there's only two possible scenarios=
:
>=20
> 1) its the right order; the smp_reschedule_interrupt() is from a
>  previous resched_task()/rcu kick or any of the other users that sends
>  it.
>=20
>  In which case we should get another smp_reschedule_interrupt() _after_=

>  the resched_task() which should observe the 'n' and promote it to an
>  'N'.
>=20
>  This doesn't happen and we're stuck with the 'n' state..
>=20
> 2) its the wrong order and the smp_reschedule_interrupt() actually
>  happened after the resched_task(), but in that case we should have
>  observed the 'n', we did not.
>=20
> Now given that 2) would mean a bug in the coherency fabric and 1) would=

> mean a lost interrupt, 1 seems like the more likely suspect.
>=20
> Joerg wanted the extra kvm tracepoints to see what the vm-exit reason
> is.
>=20

Let me think about this after I had another cup of coffee and my brain de=
cides
to follow my body in the process of waking up...

-Stefan


--fpuUAXpUFRw9iq1UbHeRI4GTBQnHn9X10
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCgAGBQJS+y7IAAoJEOhnXe7L7s6jL/AP/2keDsLnqcilX29Itk9Y/kml
ka85JF5l3b24DDRBLYoejsdE3OLRIvKhCpW3cxVxM6AHMt/vUDRF83SJsQLBzlyo
COuQOWKlq6oaGmSslghYTBreh5zgyjwiLLg6DTwuzzmRZIc+w698b1AEcOzr15W6
J6SU93aEx0Hzep0+tX9RWpHBLOZULYsSwOGx+dqxYmkz/ppk7BN3IcyGnUp+6zTd
tQHKJcW62KPymwJIWENuz+Oq6p4nE0MWfR2Kb963iD7e4KVfAA+XVsNPexh6aiC6
TLyqKKY5R9LfNB0XktsQ+2mLbGgBc/7xa1LSLrn0jqD/0AWG9fiCDwvrFQLizuaU
3arespb8hOgxVJGiR0kQ6rKxsIjT6nnLAuNk5RJnUgl45oCuY0/G9xzc/LLYlVP+
mCBdplX+ZUiqjkQ+B7WcvHuKY6+TDlWc/R0NoBN4eaDK9GRHr9QTiB698zcxyBLc
UGA6/Y5693gOXFi7N6dv/tFP7hT2izQdgOZNfv9SCPWxAi7eUEmsaO6o9s4G9HtQ
0AQFy0e+cvxG7P/vIdM1Nri84iiSYUADcS5ini2dx7PhCkVnatfmFSi0fUgBN6n0
Akl7cRZKc9iExOCm1N8DOPgp+YJBJHt1taGRrCJzYCXZm9EPeBqKyv2Isxcirhui
ZqPF7GvqHeTYoqIRrLk+
=ahtb
-----END PGP SIGNATURE-----

--fpuUAXpUFRw9iq1UbHeRI4GTBQnHn9X10--
