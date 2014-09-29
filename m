Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519AbaI2Gth (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 02:49:37 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:49745 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbaI2Gtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 02:49:36 -0400
Date: Sun, 28 Sep 2014 23:49:31 -0700
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Tanya Brokhman <tlinder@codeaurora.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH 1/5] mtd: ubi: Read disturb infrastructure
Message-ID: <20140929064931.GB9493@newt.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Tanya Brokhman <tlinder@codeaurora.org>,
	linux-kernel@vger.kernel.org
References: <1411886220-8208-1-git-send-email-tlinder@codeaurora.org>
 <20140928181354.GB2782@hudson.localdomain>
 <5428E42A.6090206@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5428E42A.6090206@codeaurora.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tanya,

On Mon, Sep 29, 2014 at 07:46:34AM +0300, Tanya Brokhman wrote:
> Hi Jeremiah,
> 
> On 9/28/2014 9:13 PM, Jeremiah Mahler wrote:
> >Tanya,
> >
> >On Sun, Sep 28, 2014 at 09:37:00AM +0300, Tanya Brokhman wrote:
> >>The need for performing read disturb is determined according to new
> >>statistics collected per eraseblock:
> >>- read counter: incremented at each read operation
> >>                 reset at each erase
> >>- last erase time stamp: updated at each erase
> >>
> >>This patch adds the infrastructure for the above statistics
> >>
> >>Signed-off-by: Tanya Brokhman <tlinder@codeaurora.org>
> >>---
> >...
> >>@@ -385,6 +402,38 @@ static ssize_t dev_attribute_show(struct device *dev,
> >>  	return ret;
> >>  }
> >>
> >>+static ssize_t dev_attribute_store(struct device *dev,
> >>+			   struct device_attribute *attr,
> >>+			   const char *buf, size_t count)
> >>+{
> >>+	int value;
> >>+	struct ubi_device *ubi;
> >>+
> >>+	ubi = container_of(dev, struct ubi_device, dev);
> >>+	ubi = ubi_get_device(ubi->ubi_num);
> >>+	if (!ubi)
> >>+		return -ENODEV;
> >>+

-----------
> >>+	if (kstrtos32(buf, 10, &value))
> >>+		return -EINVAL;
> >>+	/* Consider triggering full scan if threshods change */
> >>+	else if (attr == &dev_dt_threshold) {
-----------
The change I was suggesting was to add brackets to the above
conditional so that it is consistent throughout.

  if (kstrtos32(buf, 10, &value)) {
  	return -EINVAL;
  /* Consider triggering full scan if threshods change */
  } else if (attr == &dev_dt_threshold) {

NOTE: Just noticed 'threshods' should be spelled 'thresholds'

Each conditional level is treated independently so the single
line conditionals inside are just fine.

> >>+		if (value < UBI_MAX_DT_THRESHOLD)
> >>+			ubi->dt_threshold = value;
> >>+		else
> >>+			pr_err("Max supported threshold value is %d",
> >>+				   UBI_MAX_DT_THRESHOLD);
> >>+	} else if (attr == &dev_rd_threshold) {
> >>+		if (value < UBI_MAX_READCOUNTER)
> >>+			ubi->rd_threshold = value;
> >>+		else
> >>+			pr_err("Max supported threshold value is %d",
> >>+				   UBI_MAX_READCOUNTER);
> >>+	}
> >>+
> >>+	return count;
> >>+}
> >>+
> >...
> >
> >One small style nit.  As per Documentation/CodingStyle [line 169] if
> >one branch in a conditional uses braces then all branches should use
> >braces.
> >
> 
> I'm sorry but I understand it differently. From CodingStyle:
> "This does not apply if only one branch of a conditional statement is a
> single
> statement; in the latter case use braces in both branches:
> 
> if (condition) {
> 	do_this();
> 	do_that();
> } else {
> 	otherwise();
> }"
> According to my understanding this doesn't mean {} should be added in case
> of an if statement inside an if statement. So the above code seems to be
> complaint with the coding style.
> Please correct me if I'm misunderstanding something.
> 

I think we agree here.  The rule only applies to one level of an if
statement so the inner statements are treated independently from the
outer statements.  Perhaps some examples will make it more clear.

/* OK */
if (condition) {
	do_this();
	do_that();
} else {
	otherwise();
}

/* NOT OK, else needs brackets */
if (condition) {
	do_this();
	do_that();
} else
	otherwise();

/* OK */
if (condition) {
	do_this();
	if (another_condition)
		do_that();
} else {
	otherwise();
}

/* NOT OK, brackets unnecessary on single line conditional */
if (condition) {
	do_this();
	if (another_condition) {
		do_that();
	}
} else {
	otherwise();
}

I hope that helps :-)

> Thanks,
> - Tanya Brokhman
> 
> -- 
> Employee of Qualcomm Innovation Center, Inc.
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by
> The Linux Foundation

-- 
Jeremiah Mahler
jmmahler@gmail.com
http://github.com/jmahler
