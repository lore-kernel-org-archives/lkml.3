Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838AbaBJSJo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 13:09:44 -0500
Received: from service87.mimecast.com ([91.220.42.44]:38896 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbaBJSJk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 13:09:40 -0500
Message-ID: <52F915F6.9000501@arm.com>
Date: Mon, 10 Feb 2014 18:09:58 +0000
From: Sudeep Holla <Sudeep.Holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Sudeep.Holla@arm.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh@kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH RFC/RFT v2 1/8] drivers: base: support cpu cache information
 interface to userspace via sysfs
References: <1391791763-28518-1-git-send-email-sudeep.holla@arm.com> <1391791763-28518-2-git-send-email-sudeep.holla@arm.com> <20140207192925.GB18771@kroah.com>
In-Reply-To: <20140207192925.GB18771@kroah.com>
X-OriginalArrivalTime: 10 Feb 2014 18:09:38.0376 (UTC) FILETIME=[43053C80:01CF268B]
X-MC-Unique: 114021018093803001
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/14 19:29, Greg Kroah-Hartman wrote:
> On Fri, Feb 07, 2014 at 04:49:16PM +0000, Sudeep Holla wrote:
>> From: Sudeep Holla <sudeep.holla@arm.com>
>>
>> This patch adds initial support for providing processor cache information
>> to userspace through sysfs interface. This is based on already existing
>> implementations(x86, ia64, s390 and powerpc) and hence the interface is
>> intended to be fully compatible.
>>
>> The main purpose of this generic support is to avoid further code
>> duplication to support new architectures and also to unify all the existing
>> different implementations.
>>
>> This implementation maintains the hierarchy of cache objects which reflects
>> the system's cache topology. Cache objects are instantiated as needed as
>> CPUs come online. The cache objects are replicated per-cpu even if they are
>> shared. A per-cpu array of cache information maintained is used mainly for
>> sysfs-related book keeping.
> 
> I thought I asked that you not use "raw" kobjects for this, instead
> using 'struct device' or just an attribute group?
> 

Correct, sorry I should have mentioned here instead of cover letter that it's
not yet done. Since the changes involved other architectures, I posted v2 to get
early feedback and testing. More over it's one place to fix now instead of 4
unlike before.

Just adding cache as a device as you suggested won't suffice here. As we need to
track multiple cache indices for each cpu, devices are needed for each cache
index. I tried using device_create_with_groups which provides all we need in one
api for cache indices but since cpu devices are not associated with any class,
it fails if class is NULL. Any suggestions ?

--->8(something like this)
        struct device *dev = get_cpu_device(cpu);
        struct device *cache_dev =
			device_create(dev->class, dev, 0, NULL, "cache");
	
	/* then for each cache call index device_create_with_groups */

> Using a kobject means that userspace tools that use libudev have no
> chance to see these attributes at all, which is not good, right?
> 

Yes I understand that, I am looking at fixing it. Looks like none of the current
implementations cares about uevent notifications :(

Regards,
Sudeep

