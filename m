Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762AbbAPCW3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 21:22:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44418 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753948AbbAPCW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 21:22:28 -0500
Message-ID: <54B875D3.30204@redhat.com>
Date: Thu, 15 Jan 2015 21:22:11 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Suresh Siddha <sbsiddha@gmail.com>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        matt.fleming@intel.com, bp@suse.de, pbonzini@redhat.com,
        tglx@linutronix.de, luto@amacapital.net
Subject: Re: [PATCH 1/3] x86, fpu: introduce per-cpu "bool in_kernel_fpu"
References: <1421012793-30106-1-git-send-email-riel@redhat.com> <20150115191918.GA27332@redhat.com> <20150115191943.GB27332@redhat.com>
In-Reply-To: <20150115191943.GB27332@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 01/15/2015 02:19 PM, Oleg Nesterov wrote:
> interrupted_kernel_fpu_idle() tries to detect if
> kernel_fpu_begin() is safe or not. In particular it should
> obviously deny the nested kernel_fpu_begin() and this logic looks
> very confusing.
> 
> If use_eager_fpu() == T we rely on a) __thread_has_fpu() check in 
> interrupted_kernel_fpu_idle(), and b) on the fact that _begin()
> does __thread_clear_has_fpu().
> 
> Otherwise we demand that the interrupted task has no FPU if it is
> in kernel mode, this works because __kernel_fpu_begin() does clts()
> and interrupted_kernel_fpu_idle() checks X86_CR0_TS.
> 
> Add the per-cpu "bool in_kernel_fpu" variable, and change this
> code to check/set/clear it. This allows to do more cleanups and
> fixes, see the next changes.
> 
> The patch also moves WARN_ON_ONCE() under preempt_disable() just
> to make this_cpu_read() look better, this is not really needed. And
> in fact I think we should move it into __kernel_fpu_begin().
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Reviewed-by: Rik van Riel <riel@redhat.com>


- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUuHXTAAoJEM553pKExN6Di2kIAL4HZ8qbOhHOaNKBvAA7uvdj
3uFZcDdgoviKKT5yi4Q/49+AvXulKVxLuwpZoZXy74wID2J2AQ1bEiVkUKXhhbrl
4FKW412VAD61fsAXvGp4n3l++ITTfjX4rL0hk6ntJlegqnI3l2sEYIWGa+Hnlh7e
nTabtEOl3Ib1rkIKlR+6wVgogTzzLxLboGKY0aHHqYZmhlbGzWvnJ04PkgWPGFND
9rQWz/+ZhbBgpeQRQSW8syluswcs/gQah3BygIRnPFW500zDQzihxjssDSd7/X2Z
3lYq+TCWab8EGSpc4kOqgq+LU8nXxggP9nIA7LplqgpnIdAyg4YrxLvyWL5Y2Ys=
=t5LD
-----END PGP SIGNATURE-----
