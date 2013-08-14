Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760322Ab3HNVgl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 17:36:41 -0400
Received: from www.sr71.net ([198.145.64.142]:43168 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760012Ab3HNVgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 17:36:39 -0400
Message-ID: <520BF862.6070008@sr71.net>
Date: Wed, 14 Aug 2013 14:36:34 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nathan Fontenot <nfont@linux.vnet.ibm.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC][PATCH] drivers: base: dynamic memory block creation
References: <1376508705-3188-1-git-send-email-sjenning@linux.vnet.ibm.com> <520BECDF.8060501@sr71.net> <20130814211454.GA17423@variantweb.net>
In-Reply-To: <20130814211454.GA17423@variantweb.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/14/2013 02:14 PM, Seth Jennings wrote:
> On Wed, Aug 14, 2013 at 01:47:27PM -0700, Dave Hansen wrote:
>> On 08/14/2013 12:31 PM, Seth Jennings wrote:
>>> +static unsigned long *memblock_present;
>>> +static bool largememory_enable __read_mostly;
>>
>> How would you see this getting used in practice?  Are you just going to
>> set this by default on ppc?  Or, would you ask the distros to put it on
>> the command-line by default?  Would it only affect machines larger than
>> a certain size?
> 
> It would not be on by default, but for people running into the problem
> on their large memory machines, we could enable this after verifying
> that any tools that operate on the memory block configs are "dynamic
> memory block aware"

I don't have any idea how you would do this in practice.  You can
obviously fix the dlpar tools that you're shipping for a given distro.
But, what about the other applications?  I could imagine things like
databases wanting to know when memory comes and goes.

>> An existing tool would not work
>> with this patch (plus boot option) since it would not know how to
>> show/hide things.  It lets _part_ of those existing tools get reused
>> since they only have to be taught how to show/hide things.
>>
>> I'd find this really intriguing if you found a way to keep even the old
>> tools working.  Instead of having an explicit show/hide, why couldn't
>> you just create the entries on open(), for instance?
> 
> Nathan and I talked about this and I'm not sure if sysfs would support
> such a thing, i.e. memory block creation when someone tried to cd into
> the memory block device config.  I wouldn't know where to start on that.

It's not that fundamentally hard.  Think of how an on-disk filesystem
works today.  You do an open('foo') and the fs goes off and tries to
figure out whether there's something named 'foo' on the disk.  If there
is, it creates inodes and dentries to back it.  In your case, instead of
going to the disk, you go look at the memory configuration.

This might require a new filesystem instead of sysfs itself, but it
would potentially be a way to have good backward compatibility.

>>> +static ssize_t memory_present_show(struct device *dev,
>>> +				  struct device_attribute *attr, char *buf)
>>> +{
>>> +	int n_bits, ret;
>>> +
>>> +	n_bits = NR_MEM_SECTIONS / sections_per_block;
>>> +	ret = bitmap_scnlistprintf(buf, PAGE_SIZE - 2,
>>> +				memblock_present, n_bits);
>>> +	buf[ret++] = '\n';
>>> +	buf[ret] = '\0';
>>> +
>>> +	return ret;
>>> +}
>>
>> Doesn't this break the one-value-per-file rule?
> 
> I didn't know there was such a rule but it might. Is there any
> acceptable way to express a ranges of values.  I would just do a
> "last_memblock_id" but the range can have holes.

The rules are written down very nicely:

	Documentation/filesystems/sysfs.txt

I'm wrong, btw....  It's acceptable to do 'arrays' of values too, not
just single ones.

