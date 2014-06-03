Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933938AbaFCRFI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 13:05:08 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:63918 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932714AbaFCRFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 13:05:06 -0400
Message-ID: <538E002F.1070907@linaro.org>
Date: Tue, 03 Jun 2014 18:04:47 +0100
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mathieu Poirier <mathieu.poirier@linaro.org>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Pratik Patel <pratikp@codeaurora.org>,
        Vikas Varshney <varshney@ti.com>, Al Grant <Al.Grant@arm.com>,
        Jonas Svennebring <jonas.svennebring@avagotech.com>,
        James King <james.king@linaro.org>,
        Panchaxari Prasannamurthy Tumkur 
	<panchaxari.prasannamurthy@linaro.org>,
        Arnd Bergmann <arnd@linaro.org>,
        Marcin Jabrzyk <marcin.jabrzyk@gmail.com>, r.sengupta@samsung.com,
        Robert Marklund <robbelibobban@gmail.com>,
        Patch Tracking <patches@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 07/11] coresight: add CoreSight ETM driver
References: <1401457391-12242-1-git-send-email-mathieu.poirier@linaro.org>	<1401457391-12242-8-git-send-email-mathieu.poirier@linaro.org>	<538DA2E0.6070103@linaro.org> <CANLsYkwWWcrQPXWHZM=B7GBDQ4SyiB9cchaXPQFzvOKQUVSMTA@mail.gmail.com>
In-Reply-To: <CANLsYkwWWcrQPXWHZM=B7GBDQ4SyiB9cchaXPQFzvOKQUVSMTA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/14 17:37, Mathieu Poirier wrote:
>>> +static ssize_t debugfs_status_read(struct file *file, char __user *user_buf,
>>> +                                size_t count, loff_t *ppos)
>>> +{
>>> +     ssize_t ret;
>>> +     uint32_t val;
>>> +     unsigned long flags;
>>> +     char *buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
>>> +     struct etm_drvdata *drvdata = file->private_data;
>>> +
>>> +     if (!buf)
>>> +             return -ENOMEM;
>>> +
>>> +     ret = clk_prepare_enable(drvdata->clk);
>>> +     if (ret)
>>> +             goto out;
>>> +
>>> +     spin_lock_irqsave(&drvdata->spinlock, flags);
>>> +
>>> +     ETM_UNLOCK(drvdata);
>>> +     val = etm_readl(drvdata, ETMCCR);
>>> +     ret += sprintf(buf, "ETMCCR: 0x%08x\n", val);
>>> +     val = etm_readl(drvdata, ETMCCER);
>>> +     ret += sprintf(buf + ret, "ETMCCER: 0x%08x\n", val);
>>> +     val = etm_readl(drvdata, ETMSCR);
>>> +     ret += sprintf(buf + ret, "ETMSCR: 0x%08x\n", val);
>>> +     val = etm_readl(drvdata, ETMIDR);
>>> +     ret += sprintf(buf + ret, "ETMIDR: 0x%08x\n", val);
>>> +     val = etm_readl(drvdata, ETMCR);
>>> +     ret += sprintf(buf + ret, "ETMCR: 0x%08x\n", val);
>>> +     val = etm_readl(drvdata, ETMTEEVR);
>>> +     ret += sprintf(buf + ret, "Enable event: 0x%08x\n", val);
>>> +     val = etm_readl(drvdata, ETMTSSCR);
>>> +     ret += sprintf(buf + ret, "Enable start/stop: 0x%08x\n", val);
>>> +     ret += sprintf(buf + ret,
>>> +                    "Enable control: CR1 0x%08x CR2 0x%08x\n",
>>> +                    etm_readl(drvdata, ETMTECR1),
>>> +                    etm_readl(drvdata, ETMTECR2));
>>> +
>>> +     ETM_LOCK(drvdata);
>>> +
>>> +     spin_unlock_irqrestore(&drvdata->spinlock, flags);
>>> +     clk_disable_unprepare(drvdata->clk);
>>> +
>>> +     ret = simple_read_from_buffer(user_buf, count, ppos, buf, ret);
>>> +out:
>>> +     kfree(buf);
>>> +     return ret;
>>> +}
>>
>> Really not sure whether this should be in the read method. If we don't
>> read the file in one go the spin_lock() we'll not get a cohesive set of
>> registers.
> 
> I get your point but since there is a possibility (even very remove)
> that any of these registers can be changed between the two read
> operations, the only reasonable solution I see is to return an error
> if  (ret > size).  What your opinion on that?

I'd prefer that we simply copy the approach used by simple_attr_read().


Daniel.
