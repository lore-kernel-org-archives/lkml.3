Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789Ab3KGA2E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 19:28:04 -0500
Received: from mga14.intel.com ([143.182.124.37]:13254 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709Ab3KGA2A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 19:28:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="385728415"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>,
        "tj@kernel.org" <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] devres: Freeing the drs after all release() are called
Thread-Topic: [PATCH] devres: Freeing the drs after all release() are called
Thread-Index: AQHO2s4lTOXnnAQ4LEmnFlwPKmbOgZoY56Sg
Date: Thu, 7 Nov 2013 00:27:56 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A01B86696@SHSMSX101.ccr.corp.intel.com>
References: <1383720018.3650.37.camel@cliu38-desktop-build>
 <20131106085859.GB9487@kroah.com>
In-Reply-To: <20131106085859.GB9487@kroah.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Greg,

> -----Original Message-----
> From: Greg KH [mailto:gregkh@linuxfoundation.org]
> Sent: Wednesday, November 06, 2013 4:59 PM
> To: Liu, Chuansheng
> Cc: dmitry.torokhov@gmail.com; tj@kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH] devres: Freeing the drs after all release() are called
> 
> On Wed, Nov 06, 2013 at 02:40:18PM +0800, Chuansheng Liu wrote:
> >
> > In release_nodes(), it will call dr->node.release() and kfree
> > dr one by one.
> >
> > But sometimes the previous dr maybe be used by next .release(),
> > such as:
> > [50314.855534]  [<c12b172f>] ? synchronize_irq+0x3f/0xb0
> > [50314.861193]  [<c12b18e9>] __free_irq+0x149/0x200
> > [50314.866367]  [<c12b19e3>] free_irq+0x43/0xa0
> > [50314.871152]  [<c12b4864>] devm_irq_release+0x14/0x20
> > [50314.876713]  [<c169e806>] release_nodes+0x136/0x1b0
> > [50314.882178]  [<c169ee79>] devres_release_all+0x39/0x60
> > [50314.887935]  [<c169b411>] __device_release_driver+0x71/0xd0
> >
> > the free_irq() will sync the last irq handling, which maybe use
> > freed dr, then it will cause memory corruption.
> >
> > Here split the dr kfreeing actions after all dr->node.release().
> 
> But you aren't really solving any problems here, how is dr being used
> after the release function is called?  Who is doing it in such a way
> that this change would really fix anything?
> 
The driver code is as below:
_INIT() {

A = devm_kzalloc();
B= devm_request_threaded_irq(isr_handler);
C = devm_kzalloc();
}

When driver _EXIT, the devres_release_all () will be called.
The C will be kfreed before B, but when freeing irq B, the pending isr_handler() possibly
will access the memory B which has been freed.
Then the memory corruption occurred.

This patch can solve this scenario.
Thanks.



