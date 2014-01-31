Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255AbaAaK4a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 05:56:30 -0500
Received: from wapice.fi ([81.209.51.2]:50897 "EHLO brando.wapice.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932121AbaAaK43 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 05:56:29 -0500
From: Jouko Haapaluoma <jouko.haapaluoma@wapice.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: =?iso-8859-1?Q?Sami_Pietik=E4inen?= <Sami.Pietikainen@wapice.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        "vinod.koul@intel.com" <vinod.koul@intel.com>
Subject: RE: [RFC PATCH 0/2] dmaengine: at_hdmac: fix locking according to
 slave DMA requirements
Thread-Topic: [RFC PATCH 0/2] dmaengine: at_hdmac: fix locking according to
 slave DMA requirements
Thread-Index: AQHPG2tXgAbNvFFRIkOp5UftUR2V1Jqeo9HQ
Date: Fri, 31 Jan 2014 10:56:25 +0000
Message-ID: <C9F8415089354E4FB76F4548B3515AF484289B2A@edb1.wapice.localdomain>
References: <C9F8415089354E4FB76F4548B3515AF484286F61@edb1.wapice.localdomain>
 <cover.1390832343.git.nicolas.ferre@atmel.com>
In-Reply-To: <cover.1390832343.git.nicolas.ferre@atmel.com>
Accept-Language: en-US, fi-FI
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.0.5.157]
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

Thanks for the patches. We got the DMA working for now but the tasklet_disable() and tasklet_enable() had to be removed from atc_control().

If the device driver calls dmaengine_terminate_all() from the callback (like in our previous deadlock example), the tasklet_disable() will cause
another deadlock because the tasklet will then wait for itself to close.

The tasklet_disable() seems to be used to ensure that no tasklet is running when terminating the DMA transfers. This prevents the terminate_all from
happening in between the critical sections in the tasklet which are locked with atchan->lock. Maybe the tasklet needs to be implemented so that it can
detect and recover if the terminate_all was called in between the critical sections in the tasklet?

BR,
Jouko Haapaluoma
