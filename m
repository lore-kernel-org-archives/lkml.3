Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774Ab3CODYo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 23:24:44 -0400
Received: from mail.active-venture.com ([67.228.131.205]:63483 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536Ab3CODYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 23:24:43 -0400
X-Virus-Scan: Scanned by ClamAV 0.97.2 (no viruses);
  Thu, 14 Mar 2013 22:24:42 -0500
X-Originating-IP: 108.223.40.66
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [RFC PATCH 0/2] fs: sysfs: Add devres support
Date: Thu, 14 Mar 2013 20:24:45 -0700
Message-Id: <1363317887-24009-1-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.7.9.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide devres functions for device_create_file, sysfs_create_file,
and sysfs_create_group plus the respective remove functions.

Idea is to be able to drop calls to the remove functions from the various
drivers using those calls.

Potential savings are substantial. There are more than 700 calls to
device_remove_file in the kernel, more than 500 calls to sysfs_remove_group,
and some 50 calls to sysfs_remove_file (though not all of those use dev->kobj
as parameter). Expanding the API to sysfs_create_bin_file would add another 80+
opportunities, and adding sysfs_create_link would create another 100 or so.

The approach used in this patch set is one possible solution.
Another possibility would be to not bother with sysfs and provide
devm_device_create_file, devm_device_create_group, and its remove functions
in drivers/base/core.c instead.

I am not sure which approach is better. The solution presented here is more
aligned with other devm_ functions (I think) and does not require changing
function parameters besides the first one. Providing functions in the driver
core code would mean parameter changes [sysfs_create_file(dev, attr) ->
devm_device_create_file(dev, device_attr)] and thus be more invasive and thus a
bit more risky. It would also create devres data entries even if sysfs
is not configured (if that is even possible nowadays).

One question with the presented API is how the API should look like.
Should it be

int devm_sysfs_create_file(struct device *dev, const struct attribute *attr)

or

int devm_sysfs_create_file(struct device *dev,
			   struct kobject *kobj,
			   const struct attribute *attr)

The latter would be more consistent with other devm_ functions, but the
additional parameter seems like a waste, as the kobj would presumably
always be &dev->kobj anyway.

Before I go much further with this, I would like to get some feedback from the
community if this all makes sense or not.

Note that the code is compile tested only at this time - I don't want to spend
too much time on it if turns out to be a bad idea.
