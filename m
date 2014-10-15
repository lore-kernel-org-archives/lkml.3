Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751383AbaJONcm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 09:32:42 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:51146 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbaJONck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 09:32:40 -0400
MIME-Version: 1.0
In-Reply-To: <543E7312.1020104@roeck-us.net>
References: <1413298094-9276-1-git-send-email-octavian.purdila@intel.com>
	<1413298094-9276-4-git-send-email-octavian.purdila@intel.com>
	<20141014154151.GB10067@roeck-us.net>
	<CAE1zotKpgEqAhtQvsFFee8xnX02MmhwrM0YU-6OHVZHcxiAi9g@mail.gmail.com>
	<543E7312.1020104@roeck-us.net>
Date: Wed, 15 Oct 2014 16:32:39 +0300
Message-ID: <CAE1zotL4TLpdCeaX4=1YC=9PenscvAMDXJDAdYdVRNmGcjJaeQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 3/3] i2c: show and change bus frequency via sysfs
From: Octavian Purdila <octavian.purdila@intel.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Wolfram Sang <wsa@the-dreams.de>, Johan Hovold <johan@kernel.org>,
        linux-i2c <linux-i2c@vger.kernel.org>, linux-api@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2014 at 4:13 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> On 10/15/2014 04:49 AM, Octavian Purdila wrote:
>>
>> On Tue, Oct 14, 2014 at 6:41 PM, Guenter Roeck <linux@roeck-us.net> wrote:
>>>
>>>
>>> On Tue, Oct 14, 2014 at 05:48:14PM +0300, Octavian Purdila wrote:
>>>>
>>>> This patch adds three new sysfs files: bus_frequency,
>>>> bus_min_frequency and bus_max_frequency which allows the user to view
>>>> or change the bus frequency on a per bus level.
>>>>
>>
>> <snip>
>>
>>>> +
>>>> +static DEVICE_ATTR(bus_frequency, S_IRUGO, i2c_sysfs_freq_show,
>>>> +                i2c_sysfs_freq_store);
>>>
>>>
>>> Consider using DEVICE_ATTR_RO here. Also, extra empty line.
>>>
>>
>> Unfortunately that won't work because we must transform bus_frequency
>> to a RW entry (via is_visible) if the bus can change the frequency. We
>
>
> Ah yes, you are right.
>
>> can't use DEVIE_ATTR_RW either, because transforming a RW entry to a
>> RO entry with is visible is not possible:
>>
>
> Why not ?
>
> is_visible returns the desired mode. Just like you can return mode |
> S_IWUSR,
> you can return mode & ~S_IWUSR.
>
> Am I missing something ?
>

Here is how sysfs uses is_visible:

static int create_files(struct kernfs_node *parent, struct kobject *kobj,
...
                        if (grp->is_visible) {
                                mode = grp->is_visible(kobj, *attr, i);
                                if (!mode)
                                        continue;
                        }
                        error = sysfs_add_file_mode_ns(parent, *attr, false,
                                                       (*attr)->mode | mode,
                                                       NULL);

so basically is the mode set is the original mode from the attributed
"or-ed" with the mode return by is_visible.
