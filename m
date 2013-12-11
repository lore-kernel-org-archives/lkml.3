Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911Ab3LKBc5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 20:32:57 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:46386 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186Ab3LKBcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 20:32:52 -0500
Message-ID: <52A7C0C3.2070805@codeaurora.org>
Date: Tue, 10 Dec 2013 17:32:51 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Srinivas Ramana <sramana@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/8] regmap: Add support for using regmap over ssbi
References: <1386718523-2587-1-git-send-email-sboyd@codeaurora.org> <1386718523-2587-4-git-send-email-sboyd@codeaurora.org> <20131210235000.GK11468@sirena.org.uk> <52A7AE1B.3040201@codeaurora.org> <20131211005106.GL11468@sirena.org.uk>
In-Reply-To: <20131211005106.GL11468@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/13 16:51, Mark Brown wrote:
> On Tue, Dec 10, 2013 at 04:13:15PM -0800, Stephen Boyd wrote:
>> increment reg by 1 every time through this loop. Or should we just have
>> use_single_rw == true?
> No, it doesn't - it increments the address of reg by the size of a
> register value each time.  Using use_single_rw might make sense, or if
> you can't do bulk I/O at all then hooking in via reg_read() and
> reg_write() in the config rather than trying to parse out the buffers
> might be even better (you can still make helpers to set that up).


Are you suggesting we implement the reg_read/reg_write as global helpers
that the config points to and then call regmap_init()? At a quick glance
it looks like we lose out on regmap_bulk_read() if we do that. There is
one driver that will use regmap_bulk_read(), but I suppose we can just
loop on regmap_read() and do our own increment? If we use use_single_rw
everything works and we can simplify this code to just pass the reg and
val buffers directly to ssbi_read/write.

This is what I have now.

static int regmap_ssbi_read(void *context,
                            const void *regp, size_t reg_size,
                            void *val, size_t val_size)
{
        int ret;
        u16 reg;

        BUG_ON(reg_size != 2);

        reg = *(u16 *)regp;
        while (val_size) {
                ret = ssbi_read(context, reg, val, 1);
                if (ret)
                        return ret;
                reg++;
                val += sizeof(u8);
                val_size -= sizeof(u8);
        }

        return 0;
}

With use_single_rw I think it can be this.

static int regmap_ssbi_read(void *context,
                            const void *reg, size_t reg_size,
                            void *val, size_t val_size)
{
        BUG_ON(reg_size != 2);  
        return ssbi_read(context, *(u16 *)reg, val, 1);
}

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

