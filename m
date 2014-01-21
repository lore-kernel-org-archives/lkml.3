Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586AbaAUTJn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 14:09:43 -0500
Received: from mail-bn1lp0152.outbound.protection.outlook.com ([207.46.163.152]:4567
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105AbaAUTJl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 14:09:41 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Levente Kurusa <levex@linux.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "apw@canonical.com" <apw@canonical.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>
Subject: RE: [PATCH V3 1/1] Drivers: hv: Implement the file copy service
Thread-Topic: [PATCH V3 1/1] Drivers: hv: Implement the file copy service
Thread-Index: AQHPFtTw0Ur+cw3x2keGd11Wuxh+LJqPiKmAgAAB7IA=
Date: Tue, 21 Jan 2014 19:09:38 +0000
Message-ID: <94f51d7bf34545e5b96fb5860fe8f339@BY2PR03MB299.namprd03.prod.outlook.com>
References: <1390331164-14292-1-git-send-email-kys@microsoft.com>
 <52DEC3FD.2040701@linux.com>
In-Reply-To: <52DEC3FD.2040701@linux.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [131.107.147.149]
x-o365ent-eop-header: Message processed by -  O365_ENT: Allow from ranges
 (Engineering ONLY)
x-forefront-prvs: 0098BA6C6C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009001)(6009001)(377454003)(13464003)(479174003)(51704005)(24454002)(199002)(189002)(76482001)(74706001)(47446002)(15202345003)(83072002)(87936001)(81816001)(87266001)(81542001)(80022001)(31966008)(74316001)(54316002)(2656002)(90146001)(47976001)(74502001)(15975445006)(66066001)(74876001)(74366001)(85852003)(79102001)(54356001)(46102001)(51856001)(81686001)(53806001)(65816001)(56816005)(63696002)(59766001)(85306002)(76796001)(76786001)(76576001)(33646001)(77982001)(86362001)(56776001)(74662001)(69226001)(4396001)(92566001)(93136001)(50986001)(93516002)(47736001)(83322001)(551934002)(19580405001)(2201001)(80976001)(81342001)(49866001)(19580395003)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BY2PR03MB299;H:BY2PR03MB299.namprd03.prod.outlook.com;CLIP:131.107.147.149;FPR:;InfoNoRecordsA:1;MX:1;LANG:en;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Levente Kurusa [mailto:ilevex.linux@gmail.com] On Behalf Of Levente
> Kurusa
> Sent: Tuesday, January 21, 2014 11:01 AM
> To: KY Srinivasan; gregkh@linuxfoundation.org; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; olaf@aepfle.de; apw@canonical.com;
> jasowang@redhat.com
> Subject: Re: [PATCH V3 1/1] Drivers: hv: Implement the file copy service
> 
> Hello,
> 
> On 01/21/2014 08:06 PM, K. Y. Srinivasan wrote:
> > Implement the file copy service for Linux guests on Hyper-V. This permits the
> > host to copy a file (over VMBUS) into the guest. This facility is part of
> > "guest integration services" supported on the Windows platform.
> > Here is a link that provides additional details on this functionality:
> >
> > http://technet.microsoft.com/en-us/library/dn464282.aspx
> >
> > In V1 version of the patch I have addressed comments from
> > Olaf Hering <olaf@aepfle.de> and Dan Carpenter
> <dan.carpenter@oracle.com>
> >
> > In V2 version of this patch I did some minor cleanup (making some globals
> > static). In this version of the patch I have addressed all of Olaf's
> > most recent set of comments/concerns.
> >
> > Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> > ---
> 
> Just a few comments.
> 
> > +	/*
> > +	 * The  strings sent from the host are encoded in
> > +	 * in utf16; convert it to utf8 strings.
> > +	 * The host assures us that the utf16 strings will not exceed
> > +	 * the max lengths specified. We will however, reserve room
> > +	 * for the string terminating character - in the utf16s_utf8s()
> > +	 * function we limit the size of the buffer where the converted
> > +	 * string is placed to W_MAX_PATH -1 to gaurantee
> 
> 	s/gaurantee/guarantee
I will fix this.
> 
> > +	 * that the strings can be properly terminated!
> > +	 */
> > +
> > +	switch (operation) {
> > +	case START_FILE_COPY:
> > +		memset(smsg_out, 0, sizeof(struct hv_start_fcopy));
> > +		smsg_out->hdr.operation = operation;
> > +		smsg_in = (struct hv_start_fcopy
> *)fcopy_transaction.fcopy_msg;
> > +
> > +		utf16s_to_utf8s((wchar_t *)smsg_in->file_name,
> W_MAX_PATH,
> > +				UTF16_LITTLE_ENDIAN,
> > +				(__u8 *)smsg_out->file_name, W_MAX_PATH -
> 1);
> > +
> > +		utf16s_to_utf8s((wchar_t *)smsg_in->path_name,
> W_MAX_PATH,
> > +				UTF16_LITTLE_ENDIAN,
> > +				(__u8 *)smsg_out->path_name, W_MAX_PATH -
> 1);
> > +
> > +		smsg_out->copy_flags = smsg_in->copy_flags;
> > +		smsg_out->file_size = smsg_in->file_size;
> > +		break;
> > +
> > +	default:
> > +		break;
> > +	}
> > +	up(&fcopy_transaction.read_sema);
> > +	return;
> > +}
> > +
> > [...]
> > +static ssize_t fcopy_read(struct file *file, char __user *buf,
> > +		size_t count, loff_t *ppos)
> > +{
> > +	int ret;
> > +	void *src;
> > +	size_t copy_size;
> > +	int operation;
> > +
> > +	/*
> > +	 * Wait until there is something to be read.
> > +	 */
> > +	ret = down_interruptible(&fcopy_transaction.read_sema);
> > +	if (ret)
> > +		return -EINTR;
> 
> I don't know, but since you use 'ret' only once and you don't
> even read it after, you could just simply remove it and check
> the return code of down_interruptible() directly

Good point; I will fix this.

Thank you,

K. Y
