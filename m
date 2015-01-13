Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346AbbAMQeC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 11:34:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33720 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753066AbbAMQeA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 11:34:00 -0500
Message-ID: <54B548EA.7020005@redhat.com>
Date: Tue, 13 Jan 2015 11:33:46 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        matt.fleming@intel.com, bp@suse.de, pbonzini@redhat.com,
        tglx@linutronix.de, luto@amacapital.net
Subject: Re: [RFC PATCH 05/11] x86,fpu: ensure FPU state is reloaded from
 memory if task is traced
References: <1421012793-30106-1-git-send-email-riel@redhat.com> <1421012793-30106-6-git-send-email-riel@redhat.com> <20150113161938.GA24447@redhat.com>
In-Reply-To: <20150113161938.GA24447@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 01/13/2015 11:19 AM, Oleg Nesterov wrote:
> On 01/11, riel@redhat.com wrote:
>> 
>> @@ -412,8 +412,14 @@ static inline void switch_fpu_prepare(struct
>> task_struct *old, struct task_struc bool preload =
>> tsk_used_math(new) && (use_eager_fpu() || new->thread.fpu_counter
>> > 5); if (__thread_has_fpu(old)) { -		if (!__save_init_fpu(old)) 
>> +		/* +		 * Make sure the FPU state is restored from memory next
>> time, +		 * if the task has an FPU exception pending, or the
>> task's in +		 * memory FPU state could be changed by a debugger. 
>> +		 */ +		if (!__save_init_fpu(old) ||
>> task_is_stopped_or_traced(old)) cpu = ~0;
> 
> Well, if debugger wants to change FPU state, it should call
> init_fpu() which resets .last_cpu ?

Does the ptrace (and utrace, and ... ) code actually do that?

> Plus "is_stopped" is not needed, ptracer no longer can do STOPPED
> -> TRACED transition.

I will remove _is_stopped.

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUtUjqAAoJEM553pKExN6DtXIIAKzZj0zbQq4cQ08oKr6zMZqn
qz0MyTD91+1phywX+CFOoQ45tQUzAzpAw2k+2yGUFWhMsdEQEaANirK3stZj2Lte
Jh/VTlX1Y2ZpjoHFH69S6+5jy6nAqHaUTsMQ3jiXvi4YkzjYn9JGYY/N1E7BgRV/
T2HozdKD9+h27NetPaVPymZOwgIP5Qykbl77mH3SqwFaah/8DI3K3rMem5Ze88op
hlk3FFAgB4n8WsHDKtDXOARnF1dYCnxyR9f+3mRIuLgCdYDvktXOizTUumsbojE6
hMN9lwM/r469kVh3L20asAbXNdCAAG6U/tZcoQOizGrj/L9M4V5ACAzn7w+y+kE=
=8971
-----END PGP SIGNATURE-----
