Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932199Ab3KFObN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 09:31:13 -0500
Received: from relay.parallels.com ([195.214.232.42]:48144 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756366Ab3KFObL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 09:31:11 -0500
Message-ID: <527A5269.7040900@parallels.com>
Date: Wed, 6 Nov 2013 18:30:01 +0400
From: Maxim Patlasov <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: <karl.kiniger@med.ge.com>, <jack@suse.cz>, <linux-kernel@vger.kernel.org>,
        <t.artem@lycos.com>, <linux-mm@kvack.org>, <mgorman@suse.de>,
        <tytso@mit.edu>, <fengguang.wu@intel.com>,
        <torvalds@linux-foundation.org>
Subject: Re: [PATCH] mm: add strictlimit knob
References: <20131031142612.GA28003@kipc2.localdomain>	<20131101142941.1161.40314.stgit@dhcp-10-30-17-2.sw.ru> <20131104140104.7936d263258a7a6753eb325e@linux-foundation.org>
In-Reply-To: <20131104140104.7936d263258a7a6753eb325e@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.17.2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On 11/05/2013 02:01 AM, Andrew Morton wrote:
> On Fri, 01 Nov 2013 18:31:40 +0400 Maxim Patlasov <MPatlasov@parallels.com> wrote:
>
>> "strictlimit" feature was introduced to enforce per-bdi dirty limits for
>> FUSE which sets bdi max_ratio to 1% by default:
>>
>> http://www.http.com//article.gmane.org/gmane.linux.kernel.mm/105809
>>
>> However the feature can be useful for other relatively slow or untrusted
>> BDIs like USB flash drives and DVD+RW. The patch adds a knob to enable the
>> feature:
>>
>> echo 1 > /sys/class/bdi/X:Y/strictlimit
>>
>> Being enabled, the feature enforces bdi max_ratio limit even if global (10%)
>> dirty limit is not reached. Of course, the effect is not visible until
>> max_ratio is decreased to some reasonable value.
> I suggest replacing "max_ratio" here with the much more informative
> "/sys/class/bdi/X:Y/max_ratio".
>
> Also, Documentation/ABI/testing/sysfs-class-bdi will need an update
> please.

OK, I'll update it, fix patch description and re-send the patch.

>
>>   mm/backing-dev.c |   35 +++++++++++++++++++++++++++++++++++
>>   1 file changed, 35 insertions(+)
>>
> I'm not really sure what to make of the patch.  I assume you tested it
> and observed some effect.  Could you please describe the test setup and
> the effects in some detail?

I plugged 16GB USB-flash in a node with 8GB RAM running 3.12.0-rc7 and 
started writing a huge file by "dd" (from /dev/zero to USB-flash 
mount-point). While writing I was observing "Dirty" counter as reported 
by /proc/meminfo. As expected it stabilized on a level about 1.2GB (15% 
of total RAM). Immediately after dd completed, the "umount" command took 
about 5 minutes. This corresponded to 5MB write throughput of the flash 
drive.

Then I repeated the experiment after setting tunables:

echo 1 > /sys/class/bdi/8\:16/max_ratio
echo 1 > /sys/class/bdi/8\:16/strictlimit

This time, "Dirty" counter became 100 times lesser - about 12MB and 
"umount" took about a second.

Thanks,
Maxim
