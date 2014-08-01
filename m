Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519AbaHAPi1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 11:38:27 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:36997 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049AbaHAPi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 11:38:26 -0400
MIME-Version: 1.0
In-Reply-To: <20140801151814.GF21624@htj.dyndns.org>
References: <1406891892-10992-1-git-send-email-nasa4836@gmail.com>
 <20140801125045.GA21624@htj.dyndns.org> <CAHz2CGXpG2RYNkWHdoj947HUD6ns-CwkOH82n2DJ8cegEogHQw@mail.gmail.com>
 <20140801151814.GF21624@htj.dyndns.org>
From: Jianyu Zhan <nasa4836@gmail.com>
Date: Fri, 1 Aug 2014 23:37:45 +0800
Message-ID: <CAHz2CGWXQuZnX18q5uigC1n=hQFHKjCiyNKmTgRPUH6Z3NV4sg@mail.gmail.com>
Subject: Re: [PATCH RFC] sysfs: fix the race of "parent deleted before child added"
To: Tejun Heo <tj@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Jianyu Zhan <Jianyu.Zhan@emc.com>,
        Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all,

On Fri, Aug 1, 2014 at 11:18 PM, Tejun Heo <tj@kernel.org> wrote:
>
> Which old kernel?
>

  Quite old , 2.6.32.

>>    sysfs_create_dir()
>>        if (kobj->parent)
>>             parent = kobj->parent->sd;
>>
>> I found kobj->parent is valid, so parent == kobj->parent->sd,
>> then it is passed into create_dir() function, in which it is dereferenced,
>> however  the parent passed in is NULL, so a panic.
>
> Which node?
>

           /sys/block
               |
               |
             dm-111           <======      kobj->parent
               |
               |
             dm-111p1        <======     kobj



>> Apprently, there is a race, as my case is a test of fast removal and plugging
>> of a block device.
>>
>> The race is that the kerfs_node(was sysfs_dirent) is disassociated with
>> parent kobject, but parent kobject is still alive, so we saw it.
>
> What is the race condition?  You're just describing symptoms.

In this scenario, an user behavior that removes the block device dm-111 ,
and in the meanwhile, I don't know what trigger this, but a
rescan_partition() runs on dm-111,
in turn it caused an add_partition().

And after the crash dump analysis,  I found that the parent node is
removed (kobj->parent->sd == NULL),
but kobj-parent is still alive, as my previous mail described.

So this seems an invalid add_partition() of dm-111p1 on  non-existent dm-111.

And the race is that the parent is on its removal path, but the child
is on its creating path,
and it could observe parent's middle status -- sysfs_dirent is gone,
but kobject is alive.

>> And the commit 3a198886 ("sysfs: handle 'parent deleted before child added'")
>> add a parent NULLness check before calling into create_dir(),  but I think this
>> isn't the real fix, it just narrow down the racy window.
>
> Suspicions aren't good enough justifications.  If you think there's a
> race window, please track it down and then determine what the proper
> fix is.  You're now trying to change the basic objection lifetime
> rules of the driver model without root causing what's actually going
> on.  Please don't do things like this.

Yep, you are right.

Thanks,
Jianyu Zhan
