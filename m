Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbbAMQiI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 11:38:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39595 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752272AbbAMQiG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 11:38:06 -0500
Message-ID: <54B549E2.3040303@redhat.com>
Date: Tue, 13 Jan 2015 11:37:54 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        matt.fleming@intel.com, bp@suse.de, pbonzini@redhat.com,
        tglx@linutronix.de, luto@amacapital.net
Subject: Re: [RFC PATCH 03/11] x86,fpu: move __thread_fpu_begin to when the
 task has the fpu
References: <1421012793-30106-1-git-send-email-riel@redhat.com> <1421012793-30106-4-git-send-email-riel@redhat.com> <20150113152430.GB23134@redhat.com>
In-Reply-To: <20150113152430.GB23134@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 01/13/2015 10:24 AM, Oleg Nesterov wrote:
> On 01/11, riel@redhat.com wrote:
>> 
>> --- a/arch/x86/include/asm/fpu-internal.h +++
>> b/arch/x86/include/asm/fpu-internal.h @@ -420,7 +420,6 @@ static
>> inline void switch_fpu_prepare(struct task_struct *old, struct
>> task_struc if (preload) { new->thread.fpu_counter++; 
>> set_thread_flag(TIF_LOAD_FPU); -			__thread_set_has_fpu(new); 
>> prefetch(new->thread.fpu.state); } else if (!use_eager_fpu()) 
>> stts(); @@ -436,7 +435,6 @@ static inline void
>> switch_fpu_prepare(struct task_struct *old, struct task_struc 
>> prefetch(new->thread.fpu.state); set_thread_flag(TIF_LOAD_FPU); 
>> } -			__thread_fpu_begin(new); } /* else: CR0.TS is still set
>> from a previous FPU switch */ } @@ -451,6 +449,7 @@ static inline
>> void switch_fpu_prepare(struct task_struct *old, struct
>> task_struc static inline void switch_fpu_finish(struct
>> task_struct *new) { if (test_and_clear_thread_flag(TIF_LOAD_FPU))
>> { +		__thread_fpu_begin(new); if
>> (unlikely(restore_fpu_checking(new))) drop_init_fpu(new); }
> 
> Then perhaps it makes sense to move fpu_lazy_restore() to
> fpu_finish() too ?

I do that later in the series.  I would like to keep that in a
separate changeset, for bisecting reasons.

> Either way, afaics we do not need use_eager_fpu() before
> fpu_lazy_restore(), and this reminds me that every use_eager_fpu()
> check in switch_fpu_prepare() looks confusing.

Agreed. The patch that moves fpu_lazy_restore() into
switch_fpu_finish() also removes the use_eager_fpu()
condition for that.

Another reason for it to be by itself in its own
changeset :)

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUtUniAAoJEM553pKExN6D1KkH/0jJaxlbXBWdx3XRx3KczPiH
DJzWhUanmEZzFdCuyK/V8zDI0OjDorOntTTrA3rg1StBYGYgAm3hPMiVB5YvDJ8e
8YeJ9R+5FhMxqgBSKLHIGOazOjYCCAbl/9F+uTDnkOlsyRvJiNAVuURFdeXeWPx9
2tr2PoTVyPZlfIzVHDZKke1aeN1nS5m8Dlww3Wi1NTNJaDiKcguIMvfFtMc8j6BG
NRezcbEr+4UfQbV/k6JbMdS79Svq3xg9gWNx5BRZtv6eh4ycC8BMIICSUFYh5LAm
HfCRvWZYN+mvykaGfxYnmONrdT2TXyivy0YOeyIbCOi0hx0q52XoNKA6JwBePeA=
=wEv+
-----END PGP SIGNATURE-----
