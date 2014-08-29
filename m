Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148AbaH2SnQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 14:43:16 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:35128 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196AbaH2SnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 14:43:14 -0400
X-CheckPoint: {5400C9C1-11-2100090A-C0000000}
Message-ID: <5400C9C1.4060904@tilera.com>
Date: Fri, 29 Aug 2014 14:43:13 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Pawel Moll <pawel.moll@arm.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "paul@pwsan.com" <paul@pwsan.com>, Arnd Bergmann <arnd@arndb.de>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "arm@kernel.org" <arm@kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] char: tile-srom: Remove reference to platform_bus
References: <1406298233-27876-1-git-send-email-pawel.moll@arm.com>	 <1406298233-27876-2-git-send-email-pawel.moll@arm.com>	 <53DAA605.2030500@tilera.com> <1406913678.22529.46.camel@hornet>	 <53E139C8.9000502@tilera.com> <1407515691.31897.26.camel@hornet>
In-Reply-To: <1407515691.31897.26.camel@hornet>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.9.0.23]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Resending with text/plain.)

First, sorry for the delayed response, with summer vacation and then
trying to catch up.  :-)

On 8/8/2014 12:34 PM, Pawel Moll wrote:
> On Tue, 2014-08-05 at 21:08 +0100, Chris Metcalf wrote:
>>>> In addition, we also have user binaries
>>>> in the wild that know to look for /sys/devices/platform/srom/ paths,
>>>> so I'm pretty reluctant to change this path without good reason.
>>> So what is the srom class for then if not for device discovery? And why
>>> do they look for them in the first place? To get relevant character
>>> device's data, if I understand it right?
>>>
>>> Maybe you could just register a simple "proper" platform device for all
>>> the sroms and then hang the class devices from it? I can type some code
>>> doing this if it sound reasonably?
>> By "device discovery" I meant the way you find the way in your devices
>> in /sysfs. You seem to be traversing /sys/devices/... tree, while you've
>> got almost direct access to them through /sys/class/srom and you can (I
>> believe, correct me if I'm wrong, Greg) rely on this path being stable.

Yes, this is an excellent point.  I will change the user tool to use
/sys/class instead and then it will work with the existing kernel as well
as with future kernels that incorporate your suggested change.

>> The
>> subdirectories under /sys/devices/platform/srom/ correspond to partitions
>> in the SPI-ROM, which are software constructs created by the Tilera hypervisor.
>> By default we have three, where the first holds boot data that the chip
>> can use to boot out of hardware, and the other two are smaller partitions
>> for boot- and user-specific data.  We use the /sys files primarily to get the
>> page size and sector size for the sroms, and also export other interesting
>> information like the total size of the particular srom device.
>>
>> Thank you for volunteering to write a bit of code; if that's the best
>> way to clarify this for us, fantastic, or else pointing us at existing
>> good practices or documentation would be great too.
> [...]
> @@ -350,7 +351,7 @@ static int srom_setup_minor(struct srom_dev *srom, int index)
>  		       SROM_PAGE_SIZE_OFF, sizeof(srom->page_size)) < 0)
>  		return -EIO;
>
> -	dev = device_create(srom_class, &platform_bus,
> +	dev = device_create(srom_class, srom_parent,
>  			    MKDEV(srom_major, index), srom, "%d", index);
>  	return PTR_ERR_OR_ZERO(dev);
>  }

The second argument should be &srom_parent.dev though, I think.  Right?

> Would that work for you? Note that it will move the srom class devices
> one level deeper in /sys/devices/... hierarchy.

Yes, that seems slightly unfortunately but not too problematic.  If the
consensus is that this is the way to go, I can certainly take this change
into the Tile tree.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com


