Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932175AbaHGM7G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 08:59:06 -0400
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:43106 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757473AbaHGM7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 08:59:01 -0400
Message-ID: <53E37810.1050109@codethink.co.uk>
Date: Thu, 07 Aug 2014 13:58:56 +0100
From: Rob Jones <rob.jones@codethink.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel@lists.codethink.co.uk, ian.molton@codethink.co.uk
Subject: Re: [PATCH] seq_file: Allow private data to be supplied on seq_open
References: <1406655593-12626-1-git-send-email-rob.jones@codethink.co.uk>	<20140806160259.GR18016@ZenIV.linux.org.uk>	<53E254F1.30605@codethink.co.uk> <87sil9sa50.fsf@x220.int.ebiederm.org>
In-Reply-To: <87sil9sa50.fsf@x220.int.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/08/14 20:14, Eric W. Biederman wrote:
> Rob Jones <rob.jones@codethink.co.uk> writes:
>
>> On 06/08/14 17:02, Al Viro wrote:
>>> On Tue, Jul 29, 2014 at 06:39:53PM +0100, Rob Jones wrote:
>>>
>>>> At the moment these consumers have to obtain the struct seq_file pointer
>>>> (stored by seq_open() in file->private_data) and then store a pointer to
>>>> their own data in the private field of the struct seq_file so that it
>>>> can be accessed by the iterator functions.
>>>>
>>>> Although this is not a long piece of code it is unneccessary boilerplate.
>>>
>>> How many of those do we actually have?
>>
>> A quick grep (I didn't examine them all) showed what looked like at
>> least 80 instances of the work around.
>
> I took a quick look as well and what I saw was that if we were to
> implement the helpers: seq_open_PDE_DATA, and seq_open_i_private.  That
> would cover essentially all of seq_open that set seq_file->private.  So
> my gut feel is that a seq_open_priv is the wrong helper.
>
> In the vast majority of the cases either seq_open is good enough,
> we want seq_open_private, or seq_file->private is set to PDE_DATA
> or i_private.

I completely missed seq_open_private().

Maybe because it is completely undocumented.

Having partial documentation can be worse than having no documentation
at all - if there had been no documentation I would have been obliged to
search through the code. Unfortunately, this is both tiresome and time
consuming and, given that there is a documentation file, should not be
necessary.

On a related subject, Having looked at a few uses of seq_file, I must
say that some users seem to make assumptions about the internal
workings of the module. Dangerous behaviour as only some behaviours are
documented.

e.g. The behaviour that "struct seq_file" pointer is stored in
file->private_data is documented and can therefore be relied upon but
the fact that the output buffer and its size are only defined at the
first output (and can therefore be pre-defined and pre-allocated by
user code) is not documented and could therefore change without warning.

This second behaviour is assumed in, for example, module fs/gfs2/glock.c
which could, therefore, stop working properly without warning if the
internal behaviour was changed.

>
> I think there may be 5 cases in the kernel that do something different,
> and those cases probably need a code audit.
>
>>>> seq_open() remains in place and its behaviour remains unchanged so no
>>>> existing code should be broken by this patch.
>>>
>>> I have no objections against such helper, but I's rather have it
>>> implemented via seq_open() (and as a static inline, not an export),
>>> not the other way round.  Oh, and conversion of at least some users would
>>> be nice to have as well...
>
> I have no significant objection but having both seq_open_private
> and seq_open_priv seems confusing name wise.

Rather than pursuing my original patch, I think I will document
seq_open_private() as it achieves the same objective in a slightly
different way. Had I found it initially I almost certainly wouldn't
have created the patch.

>
> Eric

-- 
Rob Jones
Codethink Ltd
mailto:rob.jones@codethink.co.uk
tel:+44 161 236 5575
