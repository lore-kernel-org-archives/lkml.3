Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758088Ab3BBTaD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 14:30:03 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:36745 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758066Ab3BBTaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 14:30:00 -0500
X-Auth-Info: 8InUb7oCfYP9SgFuNOBcbwJAkcjvHTa5uWOyf+eCyO0=
Date: Sat, 2 Feb 2013 20:29:52 +0100
From: Anatolij Gustschin <agust@denx.de>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Peter Korsgaard <jacmet@sunsite.dk>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] gpio: mpc8xxx: don't set IRQ_TYPE_NONE when creating
 irq mapping
Message-ID: <20130202202952.378af5cb@crub>
In-Reply-To: <CACRpkdYuSpLPnTV4bNnLnA64fix7HjCU2tP6NpDn7zo+HhQ4Wg@mail.gmail.com>
References: <1359461275-7059-1-git-send-email-agust@denx.de>
	<CACRpkdYuSpLPnTV4bNnLnA64fix7HjCU2tP6NpDn7zo+HhQ4Wg@mail.gmail.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Feb 2013 16:11:03 +0100
Linus Walleij <linus.walleij@linaro.org> wrote:

> On Tue, Jan 29, 2013 at 1:07 PM, Anatolij Gustschin <agust@denx.de> wrote:
> 
> > Exporting gpios throws genirq error messages like
> >
> > genirq: Setting trigger mode 0 for irq 44 failed
> >  (mpc512x_irq_set_type+0x0/0x18c)
> >
> > Do not set IRQ_TYPE_NONE in mapping function. Setting this type here
> > ends up in returning error code in driver's irq_set_type() function
> > and this triggers the genirq error message.
> >
> > Signed-off-by: Anatolij Gustschin <agust@denx.de>
> > ---
> >  drivers/gpio/gpio-mpc8xxx.c | 1 -
> >  1 file changed, 1 deletion(-)
> >
> > diff --git a/drivers/gpio/gpio-mpc8xxx.c b/drivers/gpio/gpio-mpc8xxx.c
> > index 9ae29cc..a0b33a2 100644
> > --- a/drivers/gpio/gpio-mpc8xxx.c
> > +++ b/drivers/gpio/gpio-mpc8xxx.c
> > @@ -292,7 +292,6 @@ static int mpc8xxx_gpio_irq_map(struct irq_domain *h, unsigned int virq,
> >
> >         irq_set_chip_data(virq, h->host_data);
> >         irq_set_chip_and_handler(virq, &mpc8xxx_irq_chip, handle_level_irq);
> > -       irq_set_irq_type(virq, IRQ_TYPE_NONE);
> 
> git blame says this line was put there by the IRQ subsystem maintainer
> Thomas Gleixner.

Thomas renamed the old set_irq_type() call to irq_set_irq_type(), but
this line setting the IRQ_TYPE_NONE type was there before renaming.
It was added by commit 345e5c8a. At this time set_irq_type() checked
its type argument and returned 0 if the type argument didn't specify
some meaningful type in its type sense bits (and thus was equal to
IRQ_TYPE_NONE). Effectively this line was a nop and I wonder what was
the point of adding it.

> I feel very nervous about removing that, and you need a better explanation
> what is causing the problem and how in the commit.
> 
> Like I want to know for sure that the problem is not triggered from
> somewhere else.
> 
> Please write how and where you export this to trigger the error.

It is very simple to trigger the error, i.e. on mpc5121 based board
using mpc8xxx-gpio driver and exporting GPIO pins over sysfs gpio
interface triggers it:

# cat /sys/class/gpio/gpiochip224/base 
224
# echo 229 > /sys/class/gpio/export
[   83.753709] genirq: Setting trigger mode 0 for irq 44 failed (mpc512x_irq_set_type+0x0/0x164)

Similar error messages appear in the kernel boot log since the
board specifies GPIOs for matrix keypad and also SD Card write
protect and card detect GPIOs in its device tree. For all these
GPIOs there is an error message in the log. Here is an example
call path shown by dump_stack() added in kernel/irq/manage.c:

[    1.645277] genirq: Setting trigger mode 0 for irq 38 failed (mpc512x_irq_set_type+0x0/0x164)
[    1.656118] Call Trace:
[    1.658562] [cf83dc60] [c00088cc] show_stack+0x10c/0x1c0 (unreliable)
[    1.664962] [cf83dcb0] [c03ae0e8] dump_stack+0x24/0x34
[    1.670065] [cf83dcc0] [c006d1bc] __irq_set_trigger+0xb8/0x150
[    1.675859] [cf83dce0] [c006ea24] irq_set_irq_type+0x4c/0x78
[    1.681483] [cf83dd10] [c01f1c10] mpc8xxx_gpio_irq_map+0x70/0x88
[    1.687457] [cf83dd20] [c0070578] irq_domain_associate_many+0x104/0x1e4
[    1.694032] [cf83dd60] [c00706ec] irq_create_mapping+0x94/0x138
[    1.699915] [cf83dd80] [c01f1d04] mpc8xxx_gpio_to_irq+0x38/0x48
[    1.705810] [cf83dd90] [c01edbac] __gpio_to_irq+0x58/0x68
[    1.711177] [cf83dda0] [c02c1504] matrix_keypad_probe+0x3bc/0x7a8
[    1.717225] [cf83dde0] [c024b14c] platform_drv_probe+0x2c/0x3c
[    1.723033] [cf83ddf0] [c0249a68] driver_probe_device+0xa0/0x250
[    1.728993] [cf83de10] [c0249cc0] __driver_attach+0xa8/0xc0
[    1.734532] [cf83de30] [c0247da0] bus_for_each_dev+0x6c/0xa8
[    1.740156] [cf83de60] [c02494c8] driver_attach+0x30/0x40
[    1.745522] [cf83de70] [c0248fe0] bus_add_driver+0x198/0x26c
[    1.751144] [cf83de90] [c024a07c] driver_register+0x94/0x178
[    1.756770] [cf83deb0] [c024b2f0] platform_driver_register+0x74/0x84
[    1.763095] [cf83dec0] [c04ec6bc] matrix_keypad_driver_init+0x18/0x28
[    1.769492] [cf83ded0] [c00039c0] do_one_initcall+0x144/0x1c4
[    1.775208] [cf83df00] [c04d28d4] kernel_init_freeable+0x110/0x1b4
[    1.781347] [cf83df30] [c0003fb8] kernel_init+0x20/0x108
[    1.786634] [cf83df40] [c000ff20] ret_from_kernel_thread+0x5c/0x64

__irq_set_trigger() calls irq_set_type() callback of the mpc8xxx gpio
irq chip with the IRQ_TYPE_NONE in its 'flags' argument. This callback
is either mpc8xxx_irq_set_type() or mpc512x_irq_set_type(). Both these
functions return -EINVAL in the case if IRQ_TYPE_NONE is passed in the
flow_type argument. This return value triggers the observed error
message in __irq_set_trigger(). Modifying these callbacks to not
return an error in IRQ_TYPE_NONE case doesn't make any sense for me,
so removing the line as the patch does should be okay. If nobody
objects I'll add similar description to commit log of v2 patch.

Turning irq_set_irq_type() into a nop in case of IRQ_TYPE_NONE in
its type argument is not acceptable, commit a09b659cd describes the
reason.  

Thanks,
Anatolij
