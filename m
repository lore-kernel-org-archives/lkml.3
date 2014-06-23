Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006AbaFWOcj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 10:32:39 -0400
Received: from mail1.windriver.com ([147.11.146.13]:53253 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281AbaFWOci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 10:32:38 -0400
Message-ID: <53A83AA0.2050203@windriver.com>
Date: Mon, 23 Jun 2014 10:33:04 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] init: make rootdelay=N consistent with rootwait behaviour
References: <1401904895-18791-1-git-send-email-paul.gortmaker@windriver.com> <20140617152020.f23032953c83b621ded3901e@linux-foundation.org>
In-Reply-To: <20140617152020.f23032953c83b621ded3901e@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.56.57]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14-06-17 06:20 PM, Andrew Morton wrote:
> On Wed, 4 Jun 2014 14:01:35 -0400 Paul Gortmaker <paul.gortmaker@windriver.com> wrote:
> 
>> Currently rootdelay=N and rootwait behave differently (aside
>> from the obvious unbounded wait duration) because they are
>> at different places in the init sequence.
>>
>> The difference manifests itself for md devices because the
>> call to md_run_setup() lives between rootdelay and rootwait,
>> so if you try to use rootdelay=20 to try and allow a slow
>> RAID0 array to assemble, you get this:
>>
>> [    4.526011] sd 6:0:0:0: [sdc] Attached SCSI removable disk
>> [   22.972079] md: Waiting for all devices to be available before autodetect
>>
>> i.e. you've achieved nothing other than delaying the probing
>> 20s, when what you wanted was a 20s delay _after_ the probing
>> for md devices was initiated.
>>
>> Here we move the rootdelay code to be right beside the rootwait
>> code, so that their behaviour is consistent.
>>
>> It should be noted that in doing so, the actions based on the
>> saved_root_name[0] and initrd_load() were previously put on
>> hold by rootdelay=N and now currently will not be delayed.
>> However, I think consistent behaviour is more important than
>> matching historical behaviour of delaying the above two operations.
> 
> hm.  There may be good reasons for inserting a delay between scsi init
> and MD init - give things time to settle down before MD starts playing
> with the disks?  And I think your patch takes away that option?

In theory, md should never need that, since as per the message above,
MD does a wait_for_device_probe().  I was trying to get a wait inserted
between md0 creation and mount of root, which failed as noted.

> 
> The kernel-parameters.txt documentation for these things is rather
> vague.  We have three distinct phases, I think?
> 
> a) scsi init
> b) [md init]
> c) root mount
> 
> It's not terribly clear where rootdelay and rootwait are operating and
> I expect there are gaps in the implementation anyway.
> 
> Do you think it's worth cleaning and clearing all this up in some fashion?

Sure. Not clear how though.  One option would be to deprecate rootwait
in favour of rootdelay=-1 (or rootdelay=0) as an indication that the
user wants infinite wait.  That still means only one delay point in
your a-b-c chain above though, but I'm hoping that is OK.  Other ideas?

> 
> The whole thing is a bit of an admission of failure anyway, isn't it? 
> Why should the kernel ever need to perform arbitrary dopey delays like
> this?  Are we working around unresolved underlying bugs?

Well to be fair, I'd agree with the above.  I was trying it as a last
ditch attempt to fix an unrelated issue (and imagine that, it failed to
fix anything) but in that attempt, I noted the glaring inconsistency
between rootdelay= and rootwait.

Paul.
--

> 
