Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149AbbAVKT1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 05:19:27 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:63933 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbbAVKS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 05:18:56 -0500
Message-ID: <54C0CE8A.5080805@gmail.com>
Date: Thu, 22 Jan 2015 11:18:50 +0100
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Daniel Mack <daniel@zonque.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, arnd@arndb.de,
        ebiederm@xmission.com, gnomes@lxorguk.ukuu.org.uk, teg@jklm.no,
        jkosina@suse.cz, luto@amacapital.net, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org
CC: mtk.manpages@gmail.com, dh.herrmann@gmail.com, tixxdz@opendz.org,
        Johannes Stezenbach <js@sig21.net>, "Theodore T'so" <tytso@mit.edu>
Subject: Re: [PATCH 01/13] kdbus: add documentation
References: <1421435777-25306-1-git-send-email-gregkh@linuxfoundation.org> <1421435777-25306-2-git-send-email-gregkh@linuxfoundation.org> <54BE5DC8.70706@gmail.com> <54BE9D08.7010804@zonque.org> <54BF805B.4000609@gmail.com> <54BFDAAA.50203@zonque.org>
In-Reply-To: <54BFDAAA.50203@zonque.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On 01/21/2015 05:58 PM, Daniel Mack wrote:
> Hi Michael,
> 
> On 01/21/2015 11:32 AM, Michael Kerrisk (man-pages) wrote:
>> On 01/20/2015 07:23 PM, Daniel Mack wrote:
> 
>>> It's rather an optional driver than a core kernel feature.
>>
>> Given the various things that I've seen said about kdbus, the
>> preceding sentence makes little sense to me:
>>
>> * kdbus will be the framework supporting user-space D-Bus in the
>>   future, and also used by systemd, and so on pretty much every 
>>   desktop system.
>> * kdbus solves much of the bandwidth problem of D-Bus1. That,
>>   along with a host of other features mean that there will be
>>   a lot of user-space developers interested in using this API.
>> * Various parties in user space are already expressing strong 
>>   interest in kdbus.
>>
>> My guess from the above? This will NOT be an "optional driver". 
>> It *will be* a core kernel feature.
> 
> There will be userlands that will depend on kdbus, but that will still
> not turn the "driver" into a core Linux kernel feature. We really want
> it to be losely coupled from the rest of the kernel and optional after
> all. The kernel people are working toward making more and more things
> optional these days, and there will still be lots of systems that won't
> be using kdbus.

Make it optional and configurable if you want. But that misses my
point. kdbus is very likely to become an essential, widely used
piece of *general-purpose* piece of ABI infrastructure that will
be configured into virtually every type of system. As such, the same
standards should apply as for a "core kernel feature", whether or
not you want to cal it that.

>>> Also, the context the kdbus commands operate on originate from a
>>> mountable special-purpose file system.
>>
>> It's not clear to me how this point implies any particular API design
>> choice.
> 
> It emphasizes the fact that our ioctl API can only be used with the
> nodes exposed by kdbusfs, and vice versa. I think operations on
> driver-specific files do not justify a new 'generic' syscall API.

I see your (repeated) use of words like "driver" as just a distraction, 
I'm sorry. "Driver-specific files" is an implementation detail. The
point is that kdbus provides a complex, general-purpose feature for all
of userland. It is core infrastructure that will be used by key pieces 
of the plumbing layer, and likely by many other applications as well.
*Please* stop suggesting that it is not core infrastructure: kdbus
has the potential to be a great IPC that will be very useful to many,
many user-space developers.

(By the way, we have precedents for device/filesystem-specific system
calls. Even a recent one, in memfd_create().)

>> Notwithstanding the fact that there's a lot of (good) information in
>> kdbus.txt, there's not nearly enough for someone to create useful, 
>> robust applications that use that API (and not enough that I as a
>> reviewer feel comfortable about reviewing the API). As things stand,
>> user-space developers will be forced to decipher large amounts of kernel
>> code and existing applications in order to actually build things. And
>> when they do, they'll be using one of the worst APIs known to man: ioctl(),
>> an API that provides no type safety at all.
> 
> I don't see how ioctls are any worse than syscalls with pointers to
> structures. One can screw up compatibility either way. How is an ioctl
> wrapper/prototype any less type-safe than a syscall wrapper?

Taking that argument to the extreme, we would have no system calls 
at all, just one gigantic ioctl() ;-).

>> ioctl() is a get-out-of-jail free card when it comes to API design.
> 
> And how are syscalls different in that regard when they would both
> transport the same data structures? 

My general impression is that when it comes to system calls,
there's usually a lot more up front thought about API design.

> Also note that all kdbus ioctls
> necessarily operate on a file descriptor context, which an ioctl passes
> along by default.

I fail to see your point here. The same statement applies to multiple
special-purpose system calls (epoll, inotify, various shared memory APIs, 
and so on).

>> Rather
>> than thinking carefully and long about a set of coherent, stable APIs that 
>> provide some degree of type-safety to user-space, one just adds/changes/removes
>> an ioctl.
> 
> Adding another ioctl in the future for cases we didn't think about
> earlier would of course be considered a workaround; and even though such
> things happen all the time, it's certainly something we'd like to avoid.
> 
> However, we would also need to add another syscall in such cases, which
> is even worse IMO. So that's really not an argument against ioctls after
> all. What fundamental difference between a raw syscall and a ioctl,
> especially with regards to type safety, is there which would help us here?

Type safety helps user-space application developers. System calls have 
it, ioctl() does not.

>> And that process seems to be frequent and ongoing even now. (And 
>> it's to your great credit that the API/ABI breaks are clearly and honestly 
>> marked in the kdbus.h changelog.) All of this lightens the burden of API
>> design for kernel developers, but I'm concerned that the long-term pain
>> for user-space developers who use an API which (in my estimation) may
>> come to be widely used will be enormous.
> 
> Yes, we've jointly reviewed the API details again until just recently to
> unify structs and enums etc, and added fields to make the ioctls structs
> more versatile for possible future additions. By that, we effectively
> broke the ABI, but we did that because we know we can't do such things
> again in the future.
> 
> But again - I don't see how this would be different when using syscalls
> rather than ioctls to transport information between the driver and
> userspace. Could you elaborate?

My suspicion is that not nearly enough thinking has yet been done about
the design of the API. That's based on these observations:

* Documentation that is, considering the size of the API, *way* too thin.
* Some parts of the API not documented at all (various kdbus_item blobs)
* ABI changes happening even quite recently
* API oddities such as the 'kernel_flags' fields. Why do I need to
  be told what flags the kernel supports on *every* operation?

The above is just after a day of looking hard at kdbus.txt. I strongly
suspect I'd find a lot of other issues if I spent more time on kdbus.

>> Concretely, I'd like to see the following in kdbus.txt:
>> * A lot more detail, adding the various pieces that are currently missing.
>>   I've mentioned already the absence of detail on the item blob structures, 
>>   but there's probably several other pieces as well. My problem is that the
>>   API is so big and hard to grok that it's hard to even begin to work out
>>   what's missing from the documentation.
>> * Fleshing out the API summaries with code snippets that illustrate the
>>   use of the APIs.
>> * At least one simple working example application, complete with a walk
>>   through of how it's built and run.
>>
>> Yes, all of this is a big demand. But this is a big API that is being added 
>> to the kernel, and one that may become widely used and for a long time.
> 
> Fair enough. Everything that helps people understand and use the API in
> a sane way is a good thing to have, and so is getting an assessment from
> people how are exposed to this API for the first time.
> 
> We'll be working on restructuring the documentation.

Thanks. I know it's a big effort, and I wish you success.

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
