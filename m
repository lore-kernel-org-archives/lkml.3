Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284AbbAWXiY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 18:38:24 -0500
Received: from mout.gmx.net ([212.227.15.15]:53856 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751709AbbAWXiW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 18:38:22 -0500
Message-ID: <54C2DB5F.2050106@gmx.de>
Date: Sat, 24 Jan 2015 00:38:07 +0100
From: Hartmut Knaack <knaack.h@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:34.0) Gecko/20100101 Firefox/34.0 SeaMonkey/2.31
MIME-Version: 1.0
To: "Pandruvada, Srinivas" <srinivas.pandruvada@intel.com>,
        "Baluta, Daniel" <daniel.baluta@intel.com>
CC: "lars@metafoo.de" <lars@metafoo.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jic23@kernel.org" <jic23@kernel.org>,
        "Purdila, Octavian" <octavian.purdila@intel.com>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "Westerberg, Mika" <mika.westerberg@intel.com>,
        "pmeerw@pmeerw.net" <pmeerw@pmeerw.net>,
        "beomho.seo@samsung.com" <beomho.seo@samsung.com>,
        "gwendal@chromium.org" <gwendal@chromium.org>
Subject: Re: [RFC PATCH] iio: ak8975: Make sure chipset is always initialized
References: <1418923002-901-1-git-send-email-daniel.baluta@intel.com>	 <5494A3D6.60607@gmx.de>	 <CAEnQRZABxH5MuWEnS=RHmQqGUN0QhFTtXxnM1uyrLxvP2a-Rmg@mail.gmail.com>	 <1419110796.2843.6.camel@spandruv-hsb-test>	 <1419110952.2843.8.camel@spandruv-hsb-test>	 <CAEnQRZC_SR_p2oYq9EpDDfBi2nCAAWvYmf0tR7V7WPZRZEp79g@mail.gmail.com>	 <1421685827.4459.397.camel@spandruv-desktop.jf.intel.com>	 <CAEnQRZAfRJ+-1x_ZgRAC2Kkr2js4EQB1xA6gTJ5n0uCAZS4y2g@mail.gmail.com> <1421686560.4459.400.camel@spandruv-desktop.jf.intel.com>
In-Reply-To: <1421686560.4459.400.camel@spandruv-desktop.jf.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K0:VLqBP8w91a3bYWySWecuQtiVJWKpq+jdrzPNZv37O0RVovU6YAF
 4IOgf0jRlh6i+/2OlnkZRlGjfKZabRjC7kUobPaz/j6VBYvqbjs0LaUmeNq+kaA7mi4Y4lU
 ARvUf6awkSmRhU27Zq28NdRv0PdijEiJjPvq6382SFktgqsgAGA3HVaZHGPInsdiCgyTOLY
 veSRmMQJ2jwSXta8rk55Q==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pandruvada, Srinivas schrieb am 19.01.2015 um 17:56:
> On Mon, 2015-01-19 at 18:49 +0200, Daniel Baluta wrote: 
>> On Mon, Jan 19, 2015 at 6:44 PM, Pandruvada, Srinivas
>> <srinivas.pandruvada@intel.com> wrote:
>>> On Mon, 2015-01-19 at 16:40 +0200, Daniel Baluta wrote:
>>>> Hello,
>>>>
>>>> On Sat, Dec 20, 2014 at 11:29 PM, Pandruvada, Srinivas
>>>> <srinivas.pandruvada@intel.com> wrote:
>>>>> +Mika
>>>>>
>>>>> On Sat, 2014-12-20 at 13:26 -0800, Srinivas Pandruvada wrote:
>>>>>> On Sat, 2014-12-20 at 00:25 +0200, Daniel Baluta wrote:
>>>>>>> On Sat, Dec 20, 2014 at 12:16 AM, Hartmut Knaack <knaack.h@gmx.de> wrote:
>>>>>>>> Daniel Baluta schrieb am 18.12.2014 um 18:16:
>>>>>>>>> When using ACPI, if acpi_match_device fails then chipset enum will be
>>>>>>>>> uninitialized and &ak_def_array[chipset] will point to some bad address.
>>>>>>>>>
>>>>>> I am missing something. You are enumerated over i2c device, which was
>>>>>> created from ACPI PNP resource. There is a valid handle or and the
>>>>>> device has an ACPI companion at the least. If this failing, I have to
>>>>>> check the code for acpi i2c.
>>>>>> Can you check why this check failed? We may have bug in i2c handling.
>>>>
>>>> You are right about this. Under normal circumstances, if probe is called
>>>> then acpi_match_device will not fail. I even tried to remove the
>>>> device after probe
>>>> but before acpi_match_device, anyhow acpi_match_device was still successful :)
>>>>
>>>> This is more a matter of code correctness.
>>>>
>>>> In ak8975_match_acpi_device we have:
>>>>
>>>> »       const struct acpi_device_id *id;
>>>>
>>>> »       id = acpi_match_device(dev->driver->acpi_match_table, dev);
>>>> »       if (!id)
>>>> »       »       return NULL;
>>>> »       *chipset = (int)id->driver_data;
>>>>
>>>> Compiler complains on the fact that chipset might be uninitialized
>>>> if this returns NULL, and we shouldn't ignore this warning even this case
>>>> will never happen.
>>>>
>>> Will this fix?
>>> data->chipset = AK8975;
>>> before
>>> ak8975_match_acpi_device(&client->dev, &data->chipset);
>>>

This would fix the compiler warning, but doesn't seem the right solution for
this issue. Quoting the description of acpi_match_device:
"Return a pointer to the first matching ID on success or %NULL on failure."
So, even if it is very unlikely to for it to fail - if it does fail, the
error should be handled as quick as possible. I would favor Daniels solution
to check for a valid assignment of name.

>>
>> Yes, this is done in the original patch:
>>
>> +       *chipset = AK_MAX_TYPE;
> Since data memory is not zero alloced, other member of data are anyway
> initialized, so adding this also may be better. 

If there did not occur an error condition, it will be assigned a value
before being checked for valid ranges. And if there is an error, probe
should be aborted, anyway. So initializing *chipset doesn't seem to add
any benefit IMHO.

>>
>> .. and fixes the warning.
>>
>> Daniel.
> 
> N�����r��y���b�X��ǧv�^�)޺{.n�+����{��*"��^n�r���z���h����&���G���h�(�階�ݢj"���m�����z�ޖ���f���h���~�mml==
> 

