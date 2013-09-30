Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab3I3RNN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 13:13:13 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:51943 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755928Ab3I3RNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 13:13:12 -0400
Date: Mon, 30 Sep 2013 11:12:56 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Michal Simek <monstr@monstr.eu>
Cc: Jason Cooper <jason@lakedaemon.net>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Alan Tull <atull@altera.com>, Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dinh Nguyen <dinguyen@altera.com>,
        Philip Balister <philip@balister.org>,
        Alessandro Rubini <rubini@gnudd.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        Joe Perches <joe@perches.com>, "David S. Miller" <davem@davemloft.net>,
        Stephen Warren <swarren@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
        David Brown <davidb@codeaurora.org>, Dom Cobley <popcornmix@gmail.com>
Subject: Re: [RFC PATCH] fpga: Introduce new fpga subsystem
Message-ID: <20130930171256.GA28898@obsidianresearch.com>
References: <cover.1379519753.git.michal.simek@xilinx.com>
 <cb9a12ae95bc39626a745c2487ffd0e47e9c7b34.1379519753.git.michal.simek@xilinx.com>
 <20130918191517.GQ19937@titan.lakedaemon.net>
 <20130918203247.GA11181@obsidianresearch.com>
 <524588C9.1090600@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524588C9.1090600@monstr.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 03:31:53PM +0200, Michal Simek wrote:

> I expect that you are detecting/specifying in the driver which
> fpga is connected and you also need to know size of this device.
> Then your driver allocate buffer with this size in the kernel
> and streming data to this buffer. When this is done you are
> using another sysfs files to control device programming.

No, it just streams:

static ssize_t fpga_config_write(struct file *filp,struct kobject *kobj,
                                 struct bin_attribute *attr,
                                 char *buf, loff_t off, size_t len)
{
        struct device *dev = container_of(kobj, struct device, kobj);
        struct platform_device *pdev = to_platform_device(dev);
        struct fpga_priv *priv = platform_get_drvdata(pdev);
        uint8_t *cur = buf;
        size_t total = len;
        unsigned int bit;

        for (; len != 0; len--, cur++) {
                gpio_set_value(priv->gpio[GPIO_CCLK],0);

                for (bit = 0; bit != 8; bit++)
                        gpio_set_value(priv->data_gpio[bit],
                                       (*cur & (1<<bit)) != 0);

                gpio_set_value(priv->gpio[GPIO_CCLK],1);

                if (gpio_get_value(priv->gpio[GPIO_INIT_B]) == 0)
                        return -EIO;
        }
        return total;
}

static struct bin_attribute dev_attr_config_data = {
        .attr = {
                .name = "config_data",
                .mode = 0600,
        },
        .size = 0,
        .write = fpga_config_write,
};

User space does as many writes as necessary to send the entire
bitstream, the sysfs layer chunks things into PAGE_SIZE blocks, so it
acts much like a socket with O_NONBLOCK set.

We are controlling the other related GPIOs from userspace, but for
your purposes I would pair the data sysfs file with a control sysfs
file much like request firwmare does.

Here is a suggestion.
- Two files fpga_config_state, fpga_config_data
- fpga_config_state is a one value text string values are like
   initializing, clearing, programming, operating, error_clear_failed,
   error_bistream_crc
- Userspace writes to fpga_config_state which causes the kernel FSM
  to move to that state. The normal progression would be initializing,
  clearing, programming and finally operating
- The kernel can move to an error_* state if it detects a problem
- The programming state data from fpga_config_data to the
  configuration bus and userspace writes 'operating' once the stream
  is done to perform the post-configuration actions.

Jason
