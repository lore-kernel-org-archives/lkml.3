Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946047Ab3FUVHI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 17:07:08 -0400
Received: from relay2.sgi.com ([192.48.179.30]:42824 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1423557Ab3FUVHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 17:07:07 -0400
Message-ID: <51C4C078.2060108@sgi.com>
Date: Fri, 21 Jun 2013 14:07:04 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Nathan Zimmer <nzimmer@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>
CC: Greg KH <gregkh@linuxfoundation.org>, holt@sgi.com, rob@landley.net,
        tglx@linutronix.de, mingo@redhat.com, yinghai@kernel.org,
        akpm@linux-foundation.org, x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/2] Delay initializing of large sections of memory
References: <1371831934-156971-1-git-send-email-nzimmer@sgi.com> <20130621165142.GA32125@kroah.com> <51C48745.9030304@zytor.com> <51C48ADD.207@sgi.com>
In-Reply-To: <51C48ADD.207@sgi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 6/21/2013 10:18 AM, Nathan Zimmer wrote:
> On 06/21/2013 12:03 PM, H. Peter Anvin wrote:
>> On 06/21/2013 09:51 AM, Greg KH wrote:
>>> On Fri, Jun 21, 2013 at 11:25:32AM -0500, Nathan Zimmer wrote:
>>>> This rfc patch set delays initializing large sections of memory
>>>> until we have
>>>> started cpus.  This has the effect of reducing startup times on
>>>> large memory
>>>> systems.  On 16TB it can take over an hour to boot and most of that
>>>> time
>>>> is spent initializing memory.

On 32TB we went from 2:25 to around 20 minutes.

>>>> We avoid that bottleneck by delaying initialization until after we have
>>>> started multiple cpus and can initialize in a multithreaded manner.
>>>> This allows us to actually reduce boot time rather then just moving
>>>> around
>>>> the point of initialization.
>>>>
>>>> Mike and I have worked on this set for a while, with him doing the
>>>> most of the
>>>> heavy lifting, and are eager for some feedback.
>>> Why make this a config option at all, why not just always do this if the
>>> memory size is larger than some specific number (like 8TB?)
>>>
>>> Otherwise the distros will always enable this option, and having it be a
>>> configuration choice doesn't make any sense.
>>>
>> Since you made it a compile time option, it would be good to know how
>> much code it adds, but otherwise I agree with Greg here... this really
>> shouldn't need to be an option.  It *especially* shouldn't need to be a
>> hand-set runtime option (which looks quite complex, to boot.)
> The patchset as a whole is just over 400 lines so it doesn't add alot.
> If I were to pull the .config option it would probably remove 30 lines.
> 
> The command line option is too complex but some of the data I
> haven't found a way to get at runtime yet.

Specifically, the physical address space of each node and whether the
block size is 128M or 2G is needed.  The other params are really there as
a fallback as we have not yet verified on the largest possible machine.
The parameter is intended to be set by a configurator.  There are far
too many kernel params to leave them to chance to be set correctly.
On UV we use a utility called 'uvconfig'.

What we could do is default the values unless specifically set?
Perhaps only set the node address space?  Delaying the memory
insertion is mostly a debug aid for debugging the insertion functions.

>>
>> I suspect the cutoff for this should be a lot lower than 8 TB even, more
>> like 128 GB or so.  The only concern is to not set the cutoff so low
>> that we can end up running out of memory or with suboptimal NUMA
>> placement just because of this.

Exactly.

We test regularly on a machine that has ~4TB and the speedup is
negligible.  The problem seems to occur as the count of memory blocks
is increased over some limit.  I think going much lower might start
getting in the way of other things, like constructing transparent
huge pages, etc.

Also notice that Node 0 and the last Node already have all their memory.
There are just too many other types in the memmap that it wasn't worth
the hassle.  So unless the system has at least 6 or 8 nodes you're not
gaining much.

> Even at lower amounts of ram there is an positive impact.I it knocks
> time off
> boot even at as small as a 1TB of ram.
> 
>> Also, in case it is not bloody obvious: whatever memory the kernel image
>> was loaded into MUST be considered "online", even if it is loaded way
>> high.

Good point, we should add a check since we have that info at boot time.
Other checks might be if this is a kdump kernel, or even perhaps a KVM
kernel boot (though giving it 16TB is pretty wild.)

Thanks!
>>
>>     -hpa
