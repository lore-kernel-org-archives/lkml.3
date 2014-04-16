Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751045AbaDPB2r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 21:28:47 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:54251 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbaDPB2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 21:28:45 -0400
Message-ID: <534DDCC7.2070003@hitachi.com>
Date: Wed, 16 Apr 2014 10:28:39 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, Satoru MORIYA <satoru.moriya.br@hitachi.com>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Motohiro Kosaki <Motohiro.Kosaki@us.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kernel/panic: Add "late_kdump" option for kdump in unstable
 condition
References: <20140414045158.10846.35462.stgit@ltc230.yrl.intra.hitachi.co.jp> <20140414193153.GC4281@redhat.com> <534C8D64.2070108@hitachi.com> <20140415140853.GA17018@redhat.com>
In-Reply-To: <20140415140853.GA17018@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/04/15 23:08), Vivek Goyal wrote:
> On Tue, Apr 15, 2014 at 10:37:40AM +0900, Masami Hiramatsu wrote:
> 
> [..]
>>> Masami,
>>>
>>> So what's the alternative to kdump which is more reliable? IOW, what
>>> action you are planning to take through kmsg_dump() or through
>>> panic_notifiers?
>>>
>>> I have seen that many a times developers have tried to make the case 
>>> to save kernel buffers to NVRAM. Does it work well? Has it been proven
>>> to be more reliable than kdump?
>>
>> Yeah, one possible option is the NVRAM, but even with the serial,
>> there are other reasons to kick the notifiers, e.g.
>>  - dump to ipmi which has a very small amount of non-volatile memory
>>  - ftrace_dump() to dump "flight recorder" log to serial
> 
> So why do we need to run them in crashed kernel? Only argument I seem
> to receive that there is no guarantee that kdump kernel will successfully
> boot hence we want to run these notifiers.
> 
> But what's the guarantee that these will run successfully without creating
> futher issues? Is there data to prove it.

I think there is no guarantee, but that's same as kdump is.
However, if we can try both, there is higher possibility (more cases)
to save some information.

>>  - pvpanic notifies panic to the host.
> 
> I think this pvpanic() notification can go in kdump kernel too? Anyway,
> if one has configured kdump, then host does not have to do anything to
> save dump. Host might want to know for informational purposes that panic
> happend and system rebooted. So there should not be any need to send
> this notification immediately after crash?

Note that pvpanic works before trying to kdump with late_kdump.
Even if the kdump doesn't work, pvpanic can just notify the panic.
# of course, in that case we might better dump guest from host,
# but that's user's choice.

>> Anyway, I think the most important reason for linux developers is
>> that we have a chance to improve such horrible notifiers to safer,
> 
> I think big debate here is that we should be able to do most of it
> in second kernel. 

No, that's another topic what we talk about.

What I (and others who had argued) consider that in some rare cases,
kdump might fail to boot up the second kernel, and only for who worries
in those cases, we can give a chance.

> If you provide a knob to run these in first kernel, this functionality
> will never migrate to second kernel.

No, there are many use-cases which doesn't (and can't) use kdump
because of the limitation of resources etc. For those cases, that
functionality never migrate (means move) to the second one.

> And trying to make them safe in
> crashed kernel is a losing battle, I think.

Why? the best goal what users expect is both panic-notifiers and kdump
runs safely. If one of them fails, that's a bug (except for some rare
hardware-related corruption.)

> So providing this knob does not help with making these notifiers better.
> These notifiers can become better only if migrate the functionality
> to second kernel (preferrably in user space). There we can extract all
> the data from /proc/vmcore and send it whereever you want.

I see, that is also an important work, but that is done in userspace.
In kernel space, we can do something to give them a chance.

> But for that you will have to trust kdump and keep on improving it
> constantly so that it works reasonably well.

I trust you and kdump :) but I also know that in some rare cases that
kdump can't finish booting up, at least currently. So, if you sure
kdump is improved to boot up the second in any situation, I'm happy
to withdraw from this patch.

>> or at least to clarify what notifier or behavior makes kdump unstable. :-)
>>
> 
> I think that's well known. We don't have to provide a knob to prove that
> running notifiers will make kdump less reliable.

Hmm, could you state that?

Thank you,


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


