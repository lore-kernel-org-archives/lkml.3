Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975AbaETSZU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 14:25:20 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:51175 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755AbaETSZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 14:25:18 -0400
MIME-Version: 1.0
In-Reply-To: <537B9C6D.7010705@zytor.com>
References: <cover.1400538962.git.luto@amacapital.net> <276b39b6b645fb11e345457b503f17b83c2c6fd0.1400538962.git.luto@amacapital.net>
 <20140520172134.GJ2185@moon> <CALCETrWSgjc+iymPrvC9xiz1z4PqQS9e9F5mRLNnuabWTjQGQQ@mail.gmail.com>
 <20140520174759.GK2185@moon> <CALCETrUARCP0eNj5e3Kh81KDXg5AFLnoNoDHeoZcBXi9z-5F3w@mail.gmail.com>
 <20140520180104.GL2185@moon> <537B9C6D.7010705@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 20 May 2014 11:24:56 -0700
Message-ID: <CALCETrWmKvox1poGK5fBw2OBip7zMpjb-bpYrzd4EGHPDvZEHg@mail.gmail.com>
Subject: Re: [PATCH 3/4] x86,mm: Improve _install_special_mapping and fix x86
 vdso naming
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, X86 ML <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 11:18 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 05/20/2014 11:01 AM, Cyrill Gorcunov wrote:
>>>
>>> This patch should fix this issue, at least.  If there's still a way to
>>> get a native vdso that doesn't say "[vdso]", please let me know/
>>
>> Yes, having a native procfs way to detect vdso is much preferred!
>>
>
> Is there any path by which we can end up with [vdso] without a leading
> slash in /proc/self/maps?  Otherwise, why is that not "native"?

Dunno.  But before this patch the reverse was possible: we can end up
with a vdso that doesn't say [vdso].

>
>>>>   The situation get worse when task was dumped on one kernel and
>>>> then restored on another kernel where vdso content is different
>>>> from one save in image -- is such case as I mentioned we need
>>>> that named vdso proxy which redirect calls to vdso of the system
>>>> where task is restoring. And when such "restored" task get checkpointed
>>>> second time we don't dump new living vdso but save only old vdso
>>>> proxy on disk (detecting it is a different story, in short we
>>>> inject a unique mark into elf header).
>>>
>>> Yuck.  But I don't know whether the kernel can help much here.
>>
>> Some prctl which would tell kernel to put vdso at specifed address.
>> We can live without it for now so not a big deal (yet ;)
>
> mremap() will do this for you.

Except that it's buggy: it doesn't change mm->context.vdso.  For
64-bit tasks, the only consumer outside exec was arch_vma_name, and
this patch removes even that.  For 32-bit tasks, though, it's needed
for signal delivery.

--Andy
