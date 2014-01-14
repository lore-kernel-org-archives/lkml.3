Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848AbaANPRI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 10:17:08 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:50660 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735AbaANPRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 10:17:07 -0500
X-IronPort-AV: E=Sophos;i="4.95,658,1384300800"; 
   d="scan'208";a="90585596"
Message-ID: <52D554F0.9000409@citrix.com>
Date: Tue, 14 Jan 2014 15:17:04 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Olaf Hering <olaf@aepfle.de>
CC: David Vrabel <david.vrabel@citrix.com>, <linux-kernel@vger.kernel.org>,
        <boris.ostrovsky@oracle.com>, Ian Campbell <Ian.Campbell@citrix.com>,
        Jan Beulich <JBeulich@suse.com>, <xen-devel@lists.xen.org>
Subject: Re: [Xen-devel] [PATCH v2] xen-blkfront: remove type check from blkfront_setup_discard
References: <1389608052-7139-1-git-send-email-olaf@aepfle.de>	<52D3DAEE0200007800112FD4@nat28.tlf.novell.com>	<20140113120131.GA15623@aepfle.de>	<52D3EB5F02000078001130B5@nat28.tlf.novell.com>	<1389618054.13654.57.camel@kazak.uk.xensource.com>	<52D3F535020000780011311B@nat28.tlf.novell.com>	<52D3EE14.3080609@citrix.com> <20140114145328.GA12888@aepfle.de>
In-Reply-To: <20140114145328.GA12888@aepfle.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/01/14 14:53, Olaf Hering wrote:
> On Mon, Jan 13, David Vrabel wrote:
> 
>> Can we have a patch to blkif.h that clarifies this?
> 
> What about this change?
> 
> diff --git a/xen/include/public/io/blkif.h b/xen/include/public/io/blkif.h
> index 84eb7fd..56e2faa 100644
> --- a/xen/include/public/io/blkif.h
> +++ b/xen/include/public/io/blkif.h
> @@ -194,6 +194,7 @@
>   * discard-secure
>   *      Values:         0/1 (boolean)
>   *      Default Value:  0
> + *      Notes:          10
>   *
>   *      A value of "1" indicates that the backend can process BLKIF_OP_DISCARD
>   *      requests with the BLKIF_DISCARD_SECURE flag set.
> @@ -323,9 +324,10 @@
>   *     For full interoperability, block front and backends should publish
>   *     identical ring parameters, adjusted for unit differences, to the
>   *     XenStore nodes used in both schemes.
> - * (4) Devices that support discard functionality may internally allocate
> - *     space (discardable extents) in units that are larger than the
> - *     exported logical block size.
> + * (4) Devices that support discard functionality may internally allocate space
> + *     (discardable extents) in units that are larger than the exported logical
> + *     block size. The properties discard-granularity and discard-alignment may
> + *     be present if the backing device has such requirments.

Clarify that both discard-granularity and discard-alignment must be
present if non-sector-sized granularity is required. e.g.,

"If the backing device has such discardable extents the backend must
provide both discard-granularity and discard-alignment."

You find it useful to add these recommendations:

"Backends supporting discard should include discard-granularity and
discard-alignment even if it supports discarding individual sectors.
Frontends should assume discard-aligment == 0 and discard-granularity ==
sector size if these keys are missing."

>   * (5) The discard-alignment parameter allows a physical device to be
>   *     partitioned into virtual devices that do not necessarily begin or
>   *     end on a discardable extent boundary.
> @@ -344,6 +346,8 @@
>   *     grants that can be persistently mapped in the frontend driver, but
>   *     due to the frontent driver implementation it should never be bigger
>   *     than RING_SIZE * BLKIF_MAX_SEGMENTS_PER_REQUEST.
> + *(10) The discard-secure property may be present and will be set to 1 if the
> + *     backing device supports secure discard.
>   */

David
