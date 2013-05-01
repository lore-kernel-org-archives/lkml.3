Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755168Ab3EARud (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 13:50:33 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:33173 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066Ab3EARuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 13:50:25 -0400
MIME-Version: 1.0
In-Reply-To: <51815252.4010103@zytor.com>
References: <3cdeaedaa41e258e8aa9ca83d79a936e0b9462bc.1367385613.git.luto@amacapital.net>
 <20130501113352.GA29571@pd.tnic> <20130501163404.GA6286@thunk.org>
 <518145F6.3060800@zytor.com> <CALCETrX0WEGJ0UZz6PyQ4DrnpGg52S0cArDYLQ9Yjz3uic_N4A@mail.gmail.com>
 <51815252.4010103@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 1 May 2013 10:50:04 -0700
Message-ID: <CALCETrWa64s2bMVq9xJ5FBg2NH8501V-YThVO7CrJa7-0-TVHg@mail.gmail.com>
Subject: Re: [PATCH v5] x86: Enable fast strings on Intel if BIOS hasn't already
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Borislav Petkov <bp@alien8.de>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 1, 2013 at 10:35 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 05/01/2013 09:54 AM, Andy Lutomirski wrote:
>>
>> (Just my luck.  I'm currently trying to implement WT via PAT by
>> stealing a slot from either UC or UC-.)
>>
>
> NAK on that.  Use a slot in the upper half, perhaps (we already
> blacklist the CPUs for which the upper half aren't usable.)

Isn't the upper half incompatible with large pages?

Why the NAK?  Unless I've misread the spec, UC and UC- are only
different if there's a WC MTRR set, and I haven't found anything in
the kernel yet that adds a WC MTRR that actually needs that MTRR if
PAT is enabled.  I've made my way about half-way through the mtrr_add
calls so far.  (The drivers that use MTRRs are graphics devices, ivtv,
fusion MPT, myri10ge, and infiniband.)

>
> What do you want WT for, anyway?

Generically, memory regions in which writes have side effects but
reads are just reads and should be cached.

In particular, persistent (i.e. nonvolatile) memory.  There's an NDA
involved, but I can safely say (at least): there seem to be nifty
devices that aren't quite RAM that are nonetheless presented to the
system as RAM.  Write are durable, but only if they make it out of
cache before power fails or the CPU resets in such a way that caches
are invalidated but not written back.  UC and WC are a bit
heavy-handed because read caching is fine.  (PowerPC has nice
instructions for things like "write this back now", but x86 seems to
be missing any way other than WT to force data out to RAM without
invalidating the cache line.)

Making this work with a WT MTRR is probably doable, but it's IMO
rather ugly.  Even if I go that route, I'd still want to convince
graphics drivers to stop wasting MTRRs, since they don't need them and
they tend to be in short supply.

Here's an example:

http://www.tomshardware.com/news/Viking-ArxCis-NV-NVDIMM-RAM,21892.html


--Andy
