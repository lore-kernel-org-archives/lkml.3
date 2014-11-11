Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571AbaKKNxb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 08:53:31 -0500
Received: from mail-by2on0085.outbound.protection.outlook.com ([207.46.100.85]:45984
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750730AbaKKNx3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 08:53:29 -0500
Message-ID: <546214F7.1040007@opensource.altera.com>
Date: Tue, 11 Nov 2014 07:53:59 -0600
From: Thor Thayer <tthayer@opensource.altera.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: <linux-spi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] spi: spidev: Don't mangle max_speed_hz in underlying
 spi device
References: <1415442589-29434-1-git-send-email-broonie@kernel.org>
In-Reply-To: <1415442589-29434-1-git-send-email-broonie@kernel.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [64.129.157.38]
X-ClientProxiedBy: CY1PR0601CA0002.namprd06.prod.outlook.com (25.160.162.12)
 To BL2PR03MB114.namprd03.prod.outlook.com (10.255.230.14)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB114;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:(7)(6);SRVR:BL2PR03MB114;
X-Forefront-PRVS: 0392679D18
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6009001)(6049001)(24454002)(377454003)(479174003)(189002)(51704005)(199003)(87976001)(19580395003)(19580405001)(80316001)(107046002)(47776003)(64706001)(65956001)(20776003)(65806001)(83506001)(92726001)(106356001)(105586002)(86362001)(66066001)(92566001)(95666004)(99136001)(101416001)(102836001)(46102003)(33656002)(42186005)(87266999)(54356999)(76176999)(65816999)(50986999)(97736003)(31966008)(40100003)(77156002)(77096003)(122386002)(62966003)(59896002)(21056001)(110136001)(23746002)(99396003)(120916001)(50466002)(4396001);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2PR03MB114;H:[137.57.160.203];FPR:;MLV:sfv;PTR:InfoNoRecords;MX:1;A:0;LANG:en;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BL2PR03MB114;
X-OriginatorOrg: opensource.altera.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On 11/08/2014 04:29 AM, Mark Brown wrote:
> Currently spidev allows callers to set the default speed by overriding the
> max_speed_hz in the underlying device. This achieves the immediate goal but
> is not what devices expect and can easily lead to userspace trying to set
> unsupported speeds and succeeding, apart from anything else drivers can't
> set a limit on the speed using max_speed_hz as they'd expect and any other
> devices on the bus will be affected.
>
> Instead store the default speed in the spidev struct and fill this in on
> each transfer.
>
> Signed-off-by: Mark Brown<broonie@kernel.org>
> ---
>
> I've not tested this at all yet.
>
>   drivers/spi/spidev.c | 12 ++++++++++--
>   1 file changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/spi/spidev.c b/drivers/spi/spidev.c
> index e50039f..42239fd 100644
> --- a/drivers/spi/spidev.c
> +++ b/drivers/spi/spidev.c
> @@ -87,6 +87,7 @@ struct spidev_data {
>   	unsigned		users;
>   	u8			*tx_buffer;
>   	u8			*rx_buffer;
> +	u32			speed_hz;
>   };
>   
>   static LIST_HEAD(device_list);
> @@ -274,6 +275,8 @@ static int spidev_message(struct spidev_data *spidev,
>   		k_tmp->bits_per_word = u_tmp->bits_per_word;
>   		k_tmp->delay_usecs = u_tmp->delay_usecs;
>   		k_tmp->speed_hz = u_tmp->speed_hz;
> +		if (!k_tmp->speed_hz)
> +			k_tmp->speed_hz = spidev->speed_hz;
>   #ifdef VERBOSE
>   		dev_dbg(&spidev->spi->dev,
>   			"  xfer len %zd %s%s%s%dbits %u usec %uHz\n",
> @@ -377,7 +380,7 @@ spidev_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>   		retval = __put_user(spi->bits_per_word, (__u8 __user *)arg);
>   		break;
>   	case SPI_IOC_RD_MAX_SPEED_HZ:
> -		retval = __put_user(spi->max_speed_hz, (__u32 __user *)arg);
> +		retval = __put_user(spidev->speed_hz, (__u32 __user *)arg);
>   		break;
>   
>   	/* write requests */
> @@ -442,9 +445,10 @@ spidev_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>   			spi->max_speed_hz = tmp;
>   			retval = spi_setup(spi);
>   			if (retval < 0)
> -				spi->max_speed_hz = save;
> +				spidev->speed_hz = tmp;
>   			else
>   				dev_dbg(&spi->dev, "%d Hz (max)\n", tmp);
> +			spi->max_speed_hz = save;

I think the test should be if (retval >= 0) otherwise the value is only 
updated on an error. With this change, I was able to successfully change 
the SPI speed without affecting the max speed. This was tested using 
spidev_test.c on a Altera Cyclone V which includes the DesignWare SPI IP 
(spi-dw.c).

>   		}
>   		break;
>   
> @@ -570,6 +574,8 @@ static int spidev_release(struct inode *inode, struct file *filp)
>   		kfree(spidev->rx_buffer);
>   		spidev->rx_buffer = NULL;
>   
> +		spidev->speed_hz = spidev->spi->max_speed_hz;
> +
>   		/* ... after we unbound from the underlying device? */
>   		spin_lock_irq(&spidev->spi_lock);
>   		dofree = (spidev->spi == NULL);
> @@ -650,6 +656,8 @@ static int spidev_probe(struct spi_device *spi)
>   	}
>   	mutex_unlock(&device_list_lock);
>   
> +	spidev->speed_hz = spi->max_speed_hz;
> +
>   	if (status == 0)
>   		spi_set_drvdata(spi, spidev);
>   	else

The echo command calls spidev_write() directly. Although the speed can't 
be specified in the echo command, it did prompt me to look at that path.

In that case I think we'd need to add the .speed_hz element in 
spidev_sync_write() and spidev_sync_read().
struct spi_transfer    t = {
             .rx_buf        = spidev->rx_buffer,
             .len        = len,
             .speed_hz    = spidev->speed_hz,
         };
