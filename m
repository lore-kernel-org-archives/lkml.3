Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144AbaKCNo2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 08:44:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60927 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751713AbaKCNoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 08:44:25 -0500
Message-ID: <54578693.1050401@redhat.com>
Date: Mon, 03 Nov 2014 08:43:47 -0500
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131028 Thunderbird/17.0.10
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Fabian Frederick <fabf@skynet.be>, vgoyal@redhat.com,
        isimatu.yasuaki@jp.fujitsu.com, linux-doc@vger.kernel.org,
        kexec@lists.infradead.org, linux-api@vger.kernel.org, hedi@sgi.com
Subject: Re: [PATCH V2] kernel, add bug_on_warn
References: <1413910077-9464-1-git-send-email-prarit@redhat.com> <87bnp491b3.fsf@rustcorp.com.au> <54478367.7030505@redhat.com> <87ppd984qv.fsf@rustcorp.com.au>
In-Reply-To: <87ppd984qv.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 10/30/2014 08:25 PM, Rusty Russell wrote:
> Prarit Bhargava <prarit@redhat.com> writes:
>> On 10/22/2014 12:27 AM, Rusty Russell wrote:
>>> Prarit Bhargava <prarit@redhat.com> writes:
>>>> There have been several times where I have had to rebuild a kernel to
>>>> cause a panic when hitting a WARN() in the code in order to get a crash
>>>> dump from a system.  Sometimes this is easy to do, other times (such as
>>>> in the case of a remote admin) it is not trivial to send new images to the
>>>> user.
>>>
>>> What about during early boot?
>>
>> Hi Rusty,
>>
>> I really don't have a use case for this in early boot.  The kernel boots, the
>> initramfs, and then we run whatever init (systemd in my case).  A systemd script
>> configures kexec for kdump and that point kdump is "armed".  Doing a bug_on_warn
>> before this will simply result in a panicked system.  I don't get any "new"
>> information FWIW as I get a stack trace, etc., in both the WARN() and BUG() cases.
>>
>>>
>>> I'd recommend you use core_param().  Less code, and can be set on
>>> commandline.

Yeah, I was just starting to do this and then I saw Hedi's comment about
disabling panic_on_warn during kdump to avoid a situation where the kdump kernel
bogus panics on a warn.

So that makes the setup function look like:

static int __init panic_on_warn_setup(char *s)
{
        /* Enabling this on a kdump kernel could cause a bogus panic. */
        if (!is_kdump_kernel())
                panic_on_warn = 1;
        return 0;
}
early_param("panic_on_warn", panic_on_warn_setup);

... so I dunno if core_param would work here :(.  It would have been nice if it did.

P.
