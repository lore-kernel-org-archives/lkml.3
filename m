Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756697Ab3GYQf1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 12:35:27 -0400
Received: from www.sr71.net ([198.145.64.142]:35377 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756678Ab3GYQfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 12:35:18 -0400
Message-ID: <51F153BA.1010106@sr71.net>
Date: Thu, 25 Jul 2013 09:35:06 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Kay Sievers <kay@vrfy.org>
CC: KY Srinivasan <kys@microsoft.com>, Michal Hocko <mhocko@suse.cz>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "kamezawa.hiroyuki@gmail.com" <kamezawa.hiroyuki@gmail.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "yinghan@google.com" <yinghan@google.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: Re: [PATCH 1/1] Drivers: base: memory: Export symbols for onlining
 memory blocks
References: <1374261785-1615-1-git-send-email-kys@microsoft.com> <20130722123716.GB24400@dhcp22.suse.cz> <e06fced3ca42408b980f8aa68f4a29f3@SN2PR03MB061.namprd03.prod.outlook.com> <51EEA11D.4030007@intel.com> <3318be0a96cb4d05838d76dc9d088cc0@SN2PR03MB061.namprd03.prod.outlook.com> <51EEA89F.9070309@intel.com> <9f351a549e76483d9148f87535567ea0@SN2PR03MB061.namprd03.prod.outlook.com> <51F00415.8070104@sr71.net> <d1f80c05986b439cbeef12bcd595b264@BLUPR03MB050.namprd03.prod.outlook.com> <51F040E8.1030507@intel.com> <20130725075705.GD12818@dhcp22.suse.cz> <4f440c8d96f34711a3f06fb18702a297@SN2PR03MB061.namprd03.prod.outlook.com> <51F13E51.7040808@sr71.net> <CAPXgP10BqFoYLOS+e=aTMqM6mAZrtuWHsrsSJ4+44m+LuzRwiQ@mail.gmail.com>
In-Reply-To: <CAPXgP10BqFoYLOS+e=aTMqM6mAZrtuWHsrsSJ4+44m+LuzRwiQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2013 08:15 AM, Kay Sievers wrote:
> Complexity, well, it's just a bit of code which belongs in the kernel.
> The mentioned unconditional hotplug loop through userspace is
> absolutely pointless. Such defaults never belong in userspace tools if
> they do not involve data that is only available in userspace and
> something would make a decision about that. Saying "hello" to
> userspace and usrspace has a hardcoded "yes" in return makes no sense
> at all. The kernel can just go ahead and do its job, like it does for
> all other devices it finds too.

Sorry, but memory is different than all other devices.  You never need a
mouse in order to add another mouse to the kernel.

I'll repaste something I said earlier in this thread:

> A system under memory pressure is going to have troubles doing a
> hot-add.  You need memory to add memory.  Of the two operations ("add"
> and "online"), "add" is the one vastly more likely to fail.  It has to
> allocate several large swaths of contiguous physical memory.  For that
> reason, the system was designed so that you could "add" and "online"
> separately.  The intention was that you could "add" far in advance and
> then "online" under memory pressure, with the "online" having *VASTLY*
> smaller memory requirements and being much more likely to succeed.

So, no, it makes no sense to just have userspace always unconditionally
online all the memory that the kernel adds.  But, the way it's set up,
we _have_ a method that can work under lots memory pressure, and it is
available for users that want it.  It was designed 10 years ago, and
maybe it's outdated, or history has proved that nobody is going to use
it the way it was designed.

If I had it to do over again, I'd probably set up configurable per-node
sets of spare kernel metadata.  That way, you could say "make sure we
have enough memory reserved to add $FOO sections to node $BAR".  Use
that for the largest allocations, then depend on PF_MEMALLOC to get us
enough for the other little bits along the way.

Also, if this is a problem, it's going to be a problem for *EVERY* user
of memory hotplug, not just hyperv.  So, let's see it fixed generically
for *EVERY* user.  Something along the lines of:

1. Come up with an interface that specifies a default policy for
   newly-added memory sections.  Currently, added memory gets "added",
   but not "onlined", and the default should stay doing that.
2. Make sure that we at least WARN_ONCE() if someone tries to online an
   already-kernel-onlined memory section.  That way, if someone trips
   over this new policy, we have a _chance_ of explaining to them what
   is going on.
3. Think about what we do in the failure case where we are able to
   "add", but fail to "online" in the kernel.  Do we tear the
   newly-added structures down and back out of the operation, or do
   we leave the memory added, but offline (what happens in the normal
   case now)?



