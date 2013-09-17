Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753Ab3IQMl3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 08:41:29 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:55310 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752270Ab3IQMl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 08:41:27 -0400
Message-ID: <52384DEE.7050003@gmail.com>
Date: Tue, 17 Sep 2013 21:41:18 +0900
From: Akira Hayakawa <ruby.wktk@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: snitzer@redhat.com
CC: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com, cesarb@cesarb.net,
        joe@perches.com, akpm@linux-foundation.org, agk@redhat.com,
        m.chehab@samsung.com
Subject: Re: staging: Add dm-writeboost
References: <5223208D.4000008@gmail.com> <20130916215357.GA5015@redhat.com>
In-Reply-To: <20130916215357.GA5015@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike,

First, thank you for your commenting.
I was looking forward to your comments.


I suppose you are sensing some "smell" in my design.
You are worrying that dm-writeboost will not only confuse users
but also fall into worst situation of giving up backward-compatibility
after merging into tree.

That dm-writeboost's design is too eccentric as a DM target makes you so.

That you said
>   determines whether a device needs formatting, etc.  Otherwise I cannot
>   see how you can properly stack DM devices on writeboost devices
>   (suspend+resume become tediously different)
is a proof of smell.

Alasdair also said
> I read a statement like that as an indication of an interface or
> architectural problem.  The device-mapper approach is to 'design out'
> problems, rather than relying on users not doing bad things.
> Study the existing interfaces used by other targets to understand
> some approaches that proved successful, then decide which ones
> come closest to your needs.

and

Mikulas said
> Another idea:
> 
> Make the interface of dm-lc (the arguments to constructor, messages and 
> the status line) the same as dm-cache, so that they can be driven by the 
> same userspace code.
Though I guess this is going too far
since dm-writeboost and dm-cache are the different things
designing them similar definitely makes sense.

are also sensing of smell.


I am afraid so I am and
I am thinking of re-designing dm-writeboost
at the fundamental architectural level.
The interfaces will be similar to that of dm-cache as a result.

This will be a really a BIG change.

> Probably best for you to publish the dm-writeboost code a git repo on
> github.com or the like.  I just don't see what benefit there is to
> putting code like this in staging.  Users already need considerable
> userspace tools and infrastructure will also be changing in the
> near-term (e.g. the migration daemon).
Yes, I agree with that regarding the current implementation.
I withdraw from the proposal for staging.
I am really sorry for Greg and others caring about dm-writeboost.
But I will be back after re-designing.
staging means lot to get 3rd party users is for sure.


Since this will be a big change.
I want to agree on the design before going forward.
I will explain why the interfaces of dm-writeboost
are designed so complicated.


Essentially,
it is because dm-writeboost supports "cache-sharing".
The functionality of sharing a cache by devices is required in some cases.

If I remove the functionality the design will be much simpler
and the code will be slightly faster.


What to be removed after re-designing follows
and they are also explaining why cache-sharing makes the design bad.

(1) writeboost-mgr (maybe)
Mike said
> - really dislike the use of an intermediate "writeboost-mgr" target to
>   administer the writeboost devices.  There is no need for this.

but I don't think having a singleton intermediate writeboost-mgr
is completely weird.
dm-thin target also has a singleton thin-pool target
that create and destroy thin devices.

Below is a description from Documentation/device-mapper/thin-provisioning.txt

  Using an existing pool device
  -----------------------------

      dmsetup create pool \
          --table "0 20971520 thin-pool $metadata_dev $data_dev \
                   $data_block_size $low_water_mark"



  i) Creating a new thinly-provisioned volume.

    To create a new thinly- provisioned volume you must send a message to an
    active pool device, /dev/mapper/pool in this example.

      dmsetup message /dev/mapper/pool 0 "create_thin 0"

    Here '0' is an identifier for the volume, a 24-bit number.  It's up
    to the caller to allocate and manage these identifiers.  If the
    identifier is already in use, the message will fail with -EEXIST.

But I do agree on having writeboost-mgr is a smell of over-engineering.
A target does nothing at all but being an admin looks little bit weird
for a design of DM target.
Maybe this should be removed.

(2) device_id and cache_id
To manage which backing devices are attached to a cache
These IDs are needed like dm-thin.
But they are not needed if I give up cache-sharing and

> - the various typedefs aren't needed (e.g. device_id, cache_id,
>   cache_nr)
will be all cleared.

(3) sysfs
>   device it will establish a proper hierarchy (see: dm_get_device).  What
>   advantages are you seeing from having/managing this sysfs tree?
One of the advantages is 
that userland tools can see the relations between devices.
Some GUI application might want to draw that by refering the sysfs.

If I get rid of the cache-sharing,
the dimension of relations between devices
will not be needed and will be removed toward userland
and the alternative is to
set/get the tunable parameters are thru message and status
like dm-cache.

In addition,
there actually is a smelling code causing by this design.
The code below add/remove the sysfs interfaces
that should be done in .ctr but is separated for
actually very complicated reason
belonging to the minor behavior of dmsetup reload.

I fully agree on removing this sysfs anyway because
I don't think I will be able to maintain this sysfs forever
and that one of the reasons why I provides userland tools in Python
as an abstraction layer.

        if (!strcasecmp(cmd, "add_sysfs")) {
                struct kobject *dev_kobj;
                r = kobject_init_and_add(&wb->kobj, &device_ktype,
                                         devices_kobj, "%u", wb->id);
                if (r) {
                        WBERR();
                        return r;
                }

                dev_kobj = get_bdev_kobject(wb->device->bdev);
                r = sysfs_create_link(&wb->kobj, dev_kobj, "device");
                if (r) {
                        WBERR();
                        kobject_del(&wb->kobj);
                        kobject_put(&wb->kobj);
                        return r;
                }

                kobject_uevent(&wb->kobj, KOBJ_ADD);
                return 0;
        }

        if (!strcasecmp(cmd, "remove_sysfs")) {
                kobject_uevent(&wb->kobj, KOBJ_REMOVE);

                sysfs_remove_link(&wb->kobj, "device");
                kobject_del(&wb->kobj);
                kobject_put(&wb->kobj);

                wb_devices[wb->id] = NULL;
                return 0;
        }


Simplify the design and
make it more possible to maintain the target
for the future is what I fully agree with.
Being adhere to cache-sharing by
risking the future maintainability doesn't pay.
Re-designing the dm-writeboost resemble to dm-cache
is a leading candidate of course.

I will ask for comment for the new design in the next reply.

Akira
