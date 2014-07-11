Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978AbaGKOeD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 10:34:03 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:61348 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048AbaGKOeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 10:34:01 -0400
X-AuditID: cbfee61b-f79f86d00000144c-6c-53bff5d65a81
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH v2 1/2] phy: qcom: Add driver for QCOM APQ8064 SATA PHY
Date: Fri, 11 Jul 2014 16:33:38 +0200
Message-id: <2632799.IFO1aEjqtg@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <53BFE8F9.7050700@linaro.org>
References: <1404903807-26032-1-git-send-email-srinivas.kandagatla@linaro.org>
 <1828880.cILxhDlkNH@amdc1032> <53BFE8F9.7050700@linaro.org>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJLMWRmVeSWpSXmKPExsVy+t9jAd3rX/cHG8ydymRx4M8ORosLT3vY
	LCbuP8tucWzHIyaLy7vmsFm07j3CbtF27BirA7vHplWdbB53ru1h8zh+YzuTx+dNcgEsUVw2
	Kak5mWWpRfp2CVwZu1a+ZC2YJ1Jx4utklgbGC3xdjJwcEgImEuefrGGGsMUkLtxbz9bFyMUh
	JLCIUeJ0Ty+U08Ik8eLOI3aQKjYBK4mJ7asYQWwRAQuJfxPmMoMUMQtcYpRYefQ5C0hCWMBb
	YsPyS6wgNouAqsTXv7vYQGxeAU2JrU0bwJpFBTwldmxfCRbnFNCSeHXvJNS2HkaJprv/mCEa
	BCV+TL4HNpRZQF5i3/6prBC2jsT+1mlsExgFZiEpm4WkbBaSsgWMzKsYRVMLkguKk9JzjfSK
	E3OLS/PS9ZLzczcxggP8mfQOxlUNFocYBTgYlXh4T6zZFyzEmlhWXJl7iFGCg1lJhPfqm/3B
	QrwpiZVVqUX58UWlOanFhxilOViUxHkPtloHCgmkJ5akZqemFqQWwWSZODilGhhN332tvmcZ
	tfHbl2OtmWdf3RffG5ttodv+kb0hevGXghrfH9s4f23tn/aqqVdwStztbXEXr2S08xrYLF81
	LflNU//Lbc8nR7d7uNh6BtxWtJw4yXY6T/I91VenZkb+Puc5375yg2wGR1TPhXyZ0NbJB0K1
	TDjui6tOdOEwdtn3muGN3JU1h34qsRRnJBpqMRcVJwIANdSwKGwCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 11, 2014 02:39:05 PM Srinivas Kandagatla wrote:
> Thankyou for the comments,
> 
> On 11/07/14 13:38, Bartlomiej Zolnierkiewicz wrote:
> >
> > Hi,
> >
> > On Wednesday, July 09, 2014 12:04:06 PM Srinivas Kandagatla wrote:
> >> Add a PHY driver for uses with AHCI based SATA controller driver on the
> >> APQ8064 family of SoCs.
> >>
> >> This patch is a forward port from Qualcomm's v3.4 andriod kernel.
> >
> > Android?
> yep.
> >
> > unused define, please remove it
> >
> Will fix these instances in next version.
> >> +
> >> +#define UNIPHY_PLL_LOCK		BIT(0)
> >> +#define SATA_PHY_TX_CAL		BIT(0)
> >> +#define SATA_PHY_RX_CAL		BIT(0)
> >> +
> >> +/* default timeout set to 1 sec */
> >> +#define TIMEOUT_MS		10000
> >> +
> >> +struct qcom_apq8064_sata_phy {
> >> +	void __iomem *mmio;
> >> +	struct clk *cfg_clk;
> >> +	struct device *dev;
> >> +};
> >> +
> >> +/* Helper function to do poll and timeout */
> >> +static int read_poll_timeout(void __iomem *addr, u32 mask)
> >> +{
> >> +	unsigned long timeout = jiffies + msecs_to_jiffies(TIMEOUT_MS);
> >> +	u32 val;
> >> +
> >> +	do {
> >> +		cpu_relax();
> >> +		val = readl_relaxed(addr);
> >> +		if (val & mask)
> >> +			break;
> >> +	} while (!time_after(jiffies, timeout));
> >
> > It would be better to use usleep_[range]() (or even msleep() if needed)
> > instead of just using cpu_relax().
> 
> We really want to poll the register here, usleep/msleep would be useful 
> if we know already know how much delay is required, but in this case the 
> its not true.

I don't mean replacing the whole function, you can still do polling with
i.e. doing usleep_range(1000, 2000) with 1000 retries.  The advantage of
doing it this way would be that processor could do some useful work or
sleep during wait time instead of just busy waiting.

One example of many how to do it:

drivers/i2c/busses/i2c-s3c2410.c:

static bool is_ack(struct s3c24xx_i2c *i2c)
{
        int tries;

        for (tries = 50; tries; --tries) {
                if (readl(i2c->regs + S3C2410_IICCON)
                        & S3C2410_IICCON_IRQPEND) {
                        if (!(readl(i2c->regs + S3C2410_IICSTAT)
                                & S3C2410_IICSTAT_LASTBIT))
                                return true;
                }
                usleep_range(1000, 2000);
        }
        dev_err(i2c->dev, "ack was not recieved\n");
        return false;
}

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

