Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763190Ab3IDREy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 13:04:54 -0400
Received: from mail-bl2lp0205.outbound.protection.outlook.com ([207.46.163.205]:13176
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752276Ab3IDREw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 13:04:52 -0400
From: Matthew Garrett <matthew.garrett@nebula.com>
To: David Woodhouse <dwmw2@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [PATCH V3 02/11] PCI: Lock down BAR access when module security
 is enabled
Thread-Topic: [PATCH V3 02/11] PCI: Lock down BAR access when module
 security is enabled
Thread-Index: AQHOqQBjqKk67KL8RE6ch/Xxg088dpm1zbuAgAAB+gA=
Date: Wed, 4 Sep 2013 17:04:46 +0000
Message-ID: <1378314286.13193.5.camel@x230>
References: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com>
	 <1378252218-18798-3-git-send-email-matthew.garrett@nebula.com>
	 <1378313861.4210.39.camel@i7.infradead.org>
In-Reply-To: <1378313861.4210.39.camel@i7.infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [209.6.207.143]
x-forefront-prvs: 095972DF2F
x-forefront-antispam-report: SFV:NSPM;SFS:(24454002)(189002)(199002)(377424004)(51704005)(51856001)(66066001)(83072001)(80022001)(33716001)(4396001)(46102001)(59766001)(77982001)(81816001)(65816001)(33646001)(81686001)(81342001)(79102001)(50986001)(47976001)(47736001)(49866001)(54356001)(74876001)(76482001)(81542001)(54316002)(56776001)(63696002)(31966008)(74502001)(74662001)(47446002)(83322001)(19580405001)(74706001)(77096001)(56816003)(76786001)(76796001)(69226001)(74366001)(19580395003)(53806001)(80976001);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR05MB224;H:BY2PR05MB222.namprd05.prod.outlook.com;CLIP:209.6.207.143;RD:InfoNoRecords;MX:1;A:1;LANG:en;
Content-Type: text/plain; charset="utf-8"
Content-ID: <7EABBCAC0D106C4BAEE37C8B8314C70B@namprd05.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: nebula.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r84H4whv024391

On Wed, 2013-09-04 at 17:57 +0100, David Woodhouse wrote:
> On Tue, 2013-09-03 at 19:50 -0400, Matthew Garrett wrote:
> > Any hardware that can potentially generate DMA has to be locked down from
> > userspace in order to avoid it being possible for an attacker to modify
> > kernel code, allowing them to circumvent disabled module loading or module
> > signing. Default to paranoid - in future we can potentially relax this for
> > sufficiently IOMMU-isolated devices.
> 
> Can you elaborate on what you mean by "sufficiently IOMMU-isolated", and
> what's missing before we can do that?

Do we have in-kernel API to guarantee that a given PCI device is
actively isolated by an IOMMU such that it can't modify any host kernel
pages that aren't explicitly intended to be writable by the device? That
seems to be the biggest constraint.

> If a given device is protected by an active IOMMU, and if there's no
> driver loaded and hence no active DMA mappings for the device in
> question, then we ought to be able to prod at it safely, right? It can't
> DMA anywhere anyway.

How does virt passthrough work in this case? The current situation
appears to be that qemu just passes the BARs through to the guest, and
it's the guest that sets things up. We'd need to be able to ensure that
there's no way the guest driver can cause DMA into the host kernel.

> And there are non-DMA considerations too, aren't there? What about just
> writing some fun stuff to a memory BAR and then writing to PCI config to
> map that BAR to an address that we can get executed by kernel code?

Yes, that's why config space is locked down for now.

-- 
Matthew Garrett <matthew.garrett@nebula.com>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
