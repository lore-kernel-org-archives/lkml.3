Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751473AbaBIB4o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 20:56:44 -0500
Received: from mail-bl2lp0205.outbound.protection.outlook.com ([207.46.163.205]:3087
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751287AbaBIB4n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 20:56:43 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH V4 1/1] Drivers: hv: Implement the file copy service
Thread-Topic: [PATCH V4 1/1] Drivers: hv: Implement the file copy service
Thread-Index: AQHPFwyDw/kR6cUigkme21buMYk+V5qqh2QAgAEe+UA=
Date: Sun, 9 Feb 2014 01:56:02 +0000
Message-ID: <bfeacfefc0f04367ae447840cfe3abc5@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1390355033-16008-1-git-send-email-kys@microsoft.com>
 <20140207231718.GA16221@kroah.com>
In-Reply-To: <20140207231718.GA16221@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [24.19.246.69]
x-forefront-prvs: 011787B9DD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(51914003)(24454002)(13464003)(199002)(189002)(377454003)(51704005)(46102001)(77982001)(4396001)(79102001)(50986001)(47976001)(49866001)(47736001)(59766001)(85306002)(53806001)(66066001)(65816001)(80022001)(51856001)(63696002)(86362001)(56816005)(90146001)(83072002)(87266001)(87936001)(2656002)(85852003)(92566001)(95416001)(86612001)(19580395003)(19580405001)(94946001)(74316001)(74366001)(94316002)(81342001)(83322001)(93516002)(74662001)(74502001)(56776001)(31966008)(54356001)(76482001)(47446002)(81686001)(54316002)(81816001)(76576001)(33646001)(76786001)(76796001)(81542001)(69226001)(74876001)(93136001)(80976001)(74706001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB297;H:BY2PR03MB299.namprd03.prod.outlook.com;CLIP:24.19.246.69;FPR:C2ECF5EE.AC265CB6.C1D2616B.8EDD0943.2039F;InfoNoRecordsA:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Friday, February 07, 2014 3:17 PM
> To: KY Srinivasan
> Cc: linux-kernel@vger.kernel.org; devel@linuxdriverproject.org; olaf@aepfle.de;
> apw@canonical.com; jasowang@redhat.com
> Subject: Re: [PATCH V4 1/1] Drivers: hv: Implement the file copy service
> 
> On Tue, Jan 21, 2014 at 05:43:53PM -0800, K. Y. Srinivasan wrote:
> > +/*
> > + * Create a char device that can support read/write for passing
> > + * the payload.
> > + */
> > +static struct cdev fcopy_cdev;
> > +static struct class *cl;
> > +static struct device *sysfs_dev;
> 
> Why not just be a misc device, you only want 1 minor number for a char
> device:
> 
> > +static int fcopy_dev_init(void)
> > +{
> > +	int result;
> > +
> > +	result = alloc_chrdev_region(&fcopy_dev, 1, 1, "hv_fcopy");
> 
> See, one minor.
> 
> > +	if (result < 0) {
> > +		pr_err("Cannot get major number\n");
> > +		return result;
> > +	}
> > +
> > +	cl = class_create(THIS_MODULE, "chardev");
> 
> That's a _really_ generic name, come on, you know better than that.
> 
> > +	if (IS_ERR(cl)) {
> > +		pr_err("Error creating fcopy class.\n");
> 
> Your error string is wrong :(
> 
> > +		result = PTR_ERR(cl);
> > +		goto err_unregister;
> > +	}
> > +
> > +	sysfs_dev = device_create(cl, NULL, fcopy_dev, "%s", "hv_fcopy");
> 
> A device at the root of sysfs?  No, you have a bus to hang devices off
> of, use that.  What do you need this device for anyway?
> 
> > +	if (IS_ERR(sysfs_dev)) {
> > +		pr_err("Device creation failed\n");
> > +		result = PTR_ERR(cl);
> > +		goto err_destroy_class;
> > +	}
> > +
> > +	cdev_init(&fcopy_cdev, &fcopy_fops);
> > +	fcopy_cdev.owner = THIS_MODULE;
> > +	fcopy_cdev.ops = &fcopy_fops;
> > +
> > +	result = cdev_add(&fcopy_cdev, fcopy_dev, 1);
> 
> Ah, to get udev to pay attention to the char device, no, just use a misc
> device, should make this whole code a lot simpler and more "obvious" as
> to what you want/need.
> 
> > +	if (result) {
> > +		pr_err("Cannot cdev_add\n");
> > +		goto err_destroy_device;
> > +	}
> > +	return result;
> > +
> > +err_destroy_device:
> > +	device_destroy(cl, fcopy_dev);
> > +err_destroy_class:
> > +	class_destroy(cl);
> > +err_unregister:
> > +	unregister_chrdev_region(fcopy_dev, 1);
> > +	return result;
> 
> 
> Ugh, I hate the cdev interface, one of these days I'll fix it up, it's
> so unwieldy...
> 
> > +static void fcopy_dev_deinit(void)
> > +{
> > +	/*
> > +	 * first kill the daemon.
> > +	 */
> > +	if (dtp != NULL)
> > +		send_sig(SIGKILL, dtp, 0);
> 
> We kill userspace daemon's from the kernel?  That's a recipe for
> disaster...
> 
> Why?  What does it matter here if the daemon keeps running, it should
> fail gracefully if the character device is removed, right?  If not, that
> needs to be fixed anyway.

Greg,

Thanks for the detailed comments; I will address these in the next version.


Regards,

K. Y
