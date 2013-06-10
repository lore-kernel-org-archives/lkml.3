Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab3FJLeH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 07:34:07 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:33127 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752347Ab3FJLeF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 07:34:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: li guang <lig.fnst@cn.fujitsu.com>
Cc: Len Brown <lenb@kernel.org>, Matthew Garrett <matthew.garrett@nebula.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        platform-driver-x86@vger.kernel.org,
        Andreas =?ISO-8859-1?Q?F=E4rber?= <afaerber@suse.de>,
        Igor Mammedov <imammedo@redhat.com>
Subject: Re: [PATCH RFC v2 2/3] ec: add ec space notifier
Date: Mon, 10 Jun 2013 13:43:09 +0200
Message-ID: <21097972.gssLReeoxv@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc4+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1370825214.21655.20.camel@liguang.fnst.cn.fujitsu.com>
References: <1370482835-764-1-git-send-email-lig.fnst@cn.fujitsu.com> <10739719.ouMOhAfYPv@vostro.rjw.lan> <1370825214.21655.20.camel@liguang.fnst.cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 10, 2013 08:46:54 AM li guang wrote:
> 在 2013-06-06四的 12:59 +0200，Rafael J. Wysocki写道：
> > On Thursday, June 06, 2013 09:40:34 AM liguang wrote:
> > > add a notifier for anyone who are instresting in
> > > ec space changing.
> > > 
> > > Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
> > 
> > I'm not going to apply this anyway, but can you please explain what's the
> > problem you're trying to solve here?
> 
> OK, currently it is for QEMU to do cpu online automatically after
> hot-plug a cpu,
> and maybe potentially for real platform's cpu
> plug/unplug implementation.
> with this notifier, we don't need any GPIOes,IO ports, and other
> hardware cost if we do have an EC chip in board to trigger kernel's 
> cpu process for this.

You need to make ACPI eject/bus/device notifications go to the processor
objects rather than to listen to the EC events.

> Yep, you said you'll reject this anyway,
> but I have to ask do this notifier offend
> any rules of your development?

Well, yes, it does.  CPU offline/online is not only for hotplugging and people
do not expect CPUs to actually physically go away after using offline.

Thanks,
Rafael


> > > ---
> > >  drivers/acpi/ec.c    |   32 ++++++++++++++++++++++++++++++++
> > >  include/linux/acpi.h |    2 ++
> > >  2 files changed, 34 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
> > > index edc0081..dee3417 100644
> > > --- a/drivers/acpi/ec.c
> > > +++ b/drivers/acpi/ec.c
> > > @@ -124,6 +124,35 @@ static int EC_FLAGS_MSI; /* Out-of-spec MSI controller */
> > >  static int EC_FLAGS_VALIDATE_ECDT; /* ASUStec ECDTs need to be validated */
> > >  static int EC_FLAGS_SKIP_DSDT_SCAN; /* Not all BIOS survive early DSDT scan */
> > >  
> > > +/* notifier chain for who are intresting in ec space changing */
> > > +static RAW_NOTIFIER_HEAD(ec_space_chain);
> > > +
> > > +int __ref register_ec_space_notifier(struct notifier_block *nb)
> > > +{
> > > +        int ret;
> > > +
> > > +        ret = raw_notifier_chain_register(&ec_space_chain, nb);
> > > +
> > > +        return ret;
> > > +}
> > > +EXPORT_SYMBOL(register_ec_space_notifier);
> > > +
> > > +void __ref unregister_ec_space_notifier(struct notifier_block *nb)
> > > +{
> > > +
> > > +        raw_notifier_chain_unregister(&ec_space_chain, nb);
> > > +}
> > > +EXPORT_SYMBOL(unregister_ec_space_notifier);
> > > +
> > > +static int ec_space_notify(void *data)
> > > +{
> > > +    int ret;
> > > +
> > > +    ret = __raw_notifier_call_chain(&ec_space_chain, 0, data, -1, NULL);
> > > +
> > > +     return notifier_to_errno(ret);
> > > +}
> > > +
> > >  /* --------------------------------------------------------------------------
> > >                               Transaction Management
> > >     -------------------------------------------------------------------------- */
> > > @@ -638,6 +667,9 @@ static u32 acpi_ec_gpe_handler(acpi_handle gpe_device,
> > >  		wake_up(&ec->wait);
> > >  		ec_check_sci(ec, acpi_ec_read_status(ec));
> > >  	}
> > > +
> > > +	ec_space_notify(data);
> > > +
> > >  	return ACPI_INTERRUPT_HANDLED | ACPI_REENABLE_GPE;
> > >  }
> > >  
> > > diff --git a/include/linux/acpi.h b/include/linux/acpi.h
> > > index 17b5b59..4fe2247 100644
> > > --- a/include/linux/acpi.h
> > > +++ b/include/linux/acpi.h
> > > @@ -158,6 +158,8 @@ extern int ec_transaction(u8 command,
> > >                            const u8 *wdata, unsigned wdata_len,
> > >                            u8 *rdata, unsigned rdata_len);
> > >  extern acpi_handle ec_get_handle(void);
> > > +extern int register_ec_space_notifier(struct notifier_block *nb);
> > > +extern void unregister_ec_space_notifier(struct notifier_block *nb);
> > >  
> > >  #if defined(CONFIG_ACPI_WMI) || defined(CONFIG_ACPI_WMI_MODULE)
> > >  
> > > 
> 
> 
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
