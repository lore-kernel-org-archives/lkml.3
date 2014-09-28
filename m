Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389AbaI1SN7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 14:13:59 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:35060 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536AbaI1SN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 14:13:58 -0400
Date: Sun, 28 Sep 2014 11:13:54 -0700
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Tanya Brokhman <tlinder@codeaurora.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH 1/5] mtd: ubi: Read disturb infrastructure
Message-ID: <20140928181354.GB2782@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Tanya Brokhman <tlinder@codeaurora.org>,
	linux-kernel@vger.kernel.org
References: <1411886220-8208-1-git-send-email-tlinder@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411886220-8208-1-git-send-email-tlinder@codeaurora.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tanya,

On Sun, Sep 28, 2014 at 09:37:00AM +0300, Tanya Brokhman wrote:
> The need for performing read disturb is determined according to new
> statistics collected per eraseblock:
> - read counter: incremented at each read operation
>                 reset at each erase
> - last erase time stamp: updated at each erase
> 
> This patch adds the infrastructure for the above statistics
> 
> Signed-off-by: Tanya Brokhman <tlinder@codeaurora.org>
> ---
...
> @@ -385,6 +402,38 @@ static ssize_t dev_attribute_show(struct device *dev,
>  	return ret;
>  }
>  
> +static ssize_t dev_attribute_store(struct device *dev,
> +			   struct device_attribute *attr,
> +			   const char *buf, size_t count)
> +{
> +	int value;
> +	struct ubi_device *ubi;
> +
> +	ubi = container_of(dev, struct ubi_device, dev);
> +	ubi = ubi_get_device(ubi->ubi_num);
> +	if (!ubi)
> +		return -ENODEV;
> +
> +	if (kstrtos32(buf, 10, &value))
> +		return -EINVAL;
> +	/* Consider triggering full scan if threshods change */
> +	else if (attr == &dev_dt_threshold) {
> +		if (value < UBI_MAX_DT_THRESHOLD)
> +			ubi->dt_threshold = value;
> +		else
> +			pr_err("Max supported threshold value is %d",
> +				   UBI_MAX_DT_THRESHOLD);
> +	} else if (attr == &dev_rd_threshold) {
> +		if (value < UBI_MAX_READCOUNTER)
> +			ubi->rd_threshold = value;
> +		else
> +			pr_err("Max supported threshold value is %d",
> +				   UBI_MAX_READCOUNTER);
> +	}
> +
> +	return count;
> +}
> +
...

One small style nit.  As per Documentation/CodingStyle [line 169] if
one branch in a conditional uses braces then all branches should use
braces.

-- 
Jeremiah Mahler
jmmahler@gmail.com
http://github.com/jmahler
