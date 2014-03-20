Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751146AbaCTEO4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 00:14:56 -0400
Received: from ozlabs.org ([203.10.76.45]:47375 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788AbaCTEOz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 00:14:55 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Joe Perches <joe@perches.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        fes@google.com, Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Simon Wood <simon@mungewell.org>
Subject: Stricter module param and sysfs permission checks
In-Reply-To: <1395211832.8649.40.camel@joe-AO722>
References: <1394818263-29947-1-git-send-email-tytso@mit.edu> <1394818720.3253.1.camel@joe-AO722> <20140314180258.GA29201@thunk.org> <87y509scl3.fsf@rustcorp.com.au> <1395032434.2556.10.camel@joe-AO722> <1395041214.2556.17.camel@joe-AO722> <87zjkmr8w1.fsf@rustcorp.com.au> <1395211832.8649.40.camel@joe-AO722>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Thu, 20 Mar 2014 13:43:44 +1030
Message-ID: <87k3bpr28n.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC's trimmed, this is not a virtio issue.

Joe Perches <joe@perches.com> writes:
> On Wed, 2014-03-19 at 17:07 +1030, Rusty Russell wrote:
>>   Ted: module_param(queue_depth, int, 444)
>>   Joe: 0444!
>>   Rusty: User perms >= group perms >= other perms?
>>   Joe: CLASS_ATTR, DEVICE_ATTR, SENSOR_ATTR and SENSOR_ATTR_2?
...
>>  	/* Default value instead of permissions? */			\
>> -	static int __param_perm_check_##name __attribute__((unused)) =	\
>> -	BUILD_BUG_ON_ZERO((perm) < 0 || (perm) > 0777 || ((perm) & 2))	\
>
> Now missing test for ((perm) & 2)
>
> Dunno if that was ever necessary.

Yeah, that was introduced by Alexey Dobriyan in 2006.  It didn't go
through me, though :(  New check is better.

allmodconfig says this breaks some things:

drivers/mtd/devices/docg3.c:
 	__ATTR(f##id##_dps0_protection_key, S_IWUGO, NULL, dps0_insert_key), \
	__ATTR(f##id##_dps1_protection_key, S_IWUGO, NULL, dps1_insert_key), \

drivers/regulator/virtual.c:
static DEVICE_ATTR(min_microvolts, 0666, show_min_uV, set_min_uV);
static DEVICE_ATTR(max_microvolts, 0666, show_max_uV, set_max_uV);
static DEVICE_ATTR(min_microamps, 0666, show_min_uA, set_min_uA);
static DEVICE_ATTR(max_microamps, 0666, show_max_uA, set_max_uA);
static DEVICE_ATTR(mode, 0666, show_mode, set_mode);

drivers/hid/hid-lg4ff.c:
static DEVICE_ATTR(range, S_IRWXU | S_IRWXG | S_IRWXO, lg4ff_range_show, lg4ff_range_store);

drivers/scsi/pm8001/pm8001_ctl.c:
static DEVICE_ATTR(update_fw, S_IRUGO|S_IWUGO,
	pm8001_show_update_fw, pm8001_store_update_fw);

... plus some staging.

So I've left that for a future patch.

Thanks,
Rusty.
