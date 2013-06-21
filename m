Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423436Ab3FURDS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 13:03:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58218 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423279Ab3FURDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 13:03:17 -0400
Message-ID: <51C48745.9030304@zytor.com>
Date: Fri, 21 Jun 2013 10:03:01 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Nathan Zimmer <nzimmer@sgi.com>, holt@sgi.com, travis@sgi.com,
        rob@landley.net, tglx@linutronix.de, mingo@redhat.com,
        yinghai@kernel.org, akpm@linux-foundation.org, x86@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 0/2] Delay initializing of large sections of memory
References: <1371831934-156971-1-git-send-email-nzimmer@sgi.com> <20130621165142.GA32125@kroah.com>
In-Reply-To: <20130621165142.GA32125@kroah.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2013 09:51 AM, Greg KH wrote:
> On Fri, Jun 21, 2013 at 11:25:32AM -0500, Nathan Zimmer wrote:
>> This rfc patch set delays initializing large sections of memory until we have
>> started cpus.  This has the effect of reducing startup times on large memory
>> systems.  On 16TB it can take over an hour to boot and most of that time
>> is spent initializing memory.
>>
>> We avoid that bottleneck by delaying initialization until after we have 
>> started multiple cpus and can initialize in a multithreaded manner.
>> This allows us to actually reduce boot time rather then just moving around
>> the point of initialization.
>>
>> Mike and I have worked on this set for a while, with him doing the most of the
>> heavy lifting, and are eager for some feedback.
> 
> Why make this a config option at all, why not just always do this if the
> memory size is larger than some specific number (like 8TB?)
> 
> Otherwise the distros will always enable this option, and having it be a
> configuration choice doesn't make any sense.
> 

Since you made it a compile time option, it would be good to know how
much code it adds, but otherwise I agree with Greg here... this really
shouldn't need to be an option.  It *especially* shouldn't need to be a
hand-set runtime option (which looks quite complex, to boot.)

I suspect the cutoff for this should be a lot lower than 8 TB even, more
like 128 GB or so.  The only concern is to not set the cutoff so low
that we can end up running out of memory or with suboptimal NUMA
placement just because of this.

Also, in case it is not bloody obvious: whatever memory the kernel image
was loaded into MUST be considered "online", even if it is loaded way high.

	-hpa




