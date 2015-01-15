Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180AbbAOCta (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 21:49:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60246 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751205AbbAOCt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 21:49:29 -0500
Message-ID: <54B72AA0.5020500@redhat.com>
Date: Wed, 14 Jan 2015 21:49:04 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        matt.fleming@intel.com, bp@suse.de, pbonzini@redhat.com,
        tglx@linutronix.de, luto@amacapital.net
Subject: Re: [RFC PATCH 06/11] x86,fpu: lazily skip fpu restore with eager
 fpu mode, too
References: <1421012793-30106-1-git-send-email-riel@redhat.com> <1421012793-30106-7-git-send-email-riel@redhat.com> <20150114183606.GA16024@redhat.com>
In-Reply-To: <20150114183606.GA16024@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 01/14/2015 01:36 PM, Oleg Nesterov wrote:
> On 01/11, riel@redhat.com wrote:
>> 
>> If the next task still has its FPU state present in the FPU
>> registers, there is no need to restore it from memory.
> 
> Another patch I can't understand...
> 
>> --- a/arch/x86/include/asm/fpu-internal.h +++
>> b/arch/x86/include/asm/fpu-internal.h @@ -435,13 +435,9 @@ static
>> inline void switch_fpu_prepare(struct task_struct *old, struct
>> task_struc old->thread.fpu.last_cpu = ~0; if (preload) { 
>> new->thread.fpu_counter++; -			if (!use_eager_fpu() &&
>> fpu_lazy_restore(new, cpu)) -				/* XXX: is this safe against
>> ptrace??? */ -				__thread_fpu_begin(new); -			else { +
>> set_thread_flag(TIF_LOAD_FPU); +			if (!fpu_lazy_restore(new,
>> cpu)) prefetch(new->thread.fpu.state); -
>> set_thread_flag(TIF_LOAD_FPU); -			}
> 
> It is not clear to me why do we set TIF_LOAD_FPU if
> fpu_lazy_restore() succeeds. __thread_fpu_begin() is cheap.
> 
> At the same time, if switch_fpu_finish() does fpu_lazy_restore()
> anyway, why this patch doesn't remove it from switch_fpu_prepare()
> ?

I have it removed now, because the prefetch does not make
much sense (as was pointed out by either you or Andy).

>> @@ -466,6 +462,10 @@ static inline void switch_fpu_finish(void)
>> 
>> __thread_fpu_begin(tsk);
>> 
>> +	/* The FPU registers already have this task's FPU state. */ +
>> if (fpu_lazy_restore(tsk, raw_smp_processor_id())) +		return; +
> 
> Now that this is called before return to user-mode, I am not sure
> this is correct. Note that __kernel_fpu_begin() doesn't clear
> fpu_owner_task if use_eager_fpu().

However, __kernel_fpu_begin() does call __thread_clear_has_fpu(),
which clears the per-cpu fpu_owner variable, which is also
evaluated by fpu_lazy_restore(), so I think this is actually
correct.

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUtyqgAAoJEM553pKExN6DFG0H+wfeZaKByANgrgUBHMYjrkEW
0C6f3lWaxyi8CPad7ghWN3GnSARpaA+OorukD3xwmubZjUc69vcNHMPW9A8hT95q
FNpRQHW/ehx6esXme+Jc7r1FCYr5Jm9hvfQ4xPm6jQQDs/Sok4vjsPgOnaa0DeHa
gqeE2cXt38kTtTgxsP7CKC/m3/B+KQ2c7ieB4XtXfWfwBNiFUiFgfRB22ip0hZCr
7D2UuatSat+zyaH8G5bHPQciEzGWARYB/SrzhmoUXrX7fGdY7fMvKUDyLH+p2SK0
0k3V4yBETi2GtMK2+z3KNlQ8TVp4/LvkpuCKbu54hHQh1sDYkDCXDpMfcwuJ4H4=
=Hah8
-----END PGP SIGNATURE-----
