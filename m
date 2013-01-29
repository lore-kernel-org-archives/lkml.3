Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009Ab3A2X4z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 18:56:55 -0500
Received: from mail1.bemta8.messagelabs.com ([216.82.243.50]:59074 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751560Ab3A2X4x convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 18:56:53 -0500
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-131.messagelabs.com!1359503803!20459966!8
X-Originating-IP: [216.166.12.180]
X-StarScan-Received: 
X-StarScan-Version: 6.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: =?iso-8859-1?Q?Peter_H=FCwe?= <PeterHuewe@gmx.de>,
        Ian Abbott <abbotti@mev.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ian Abbott <ian.abbott@mev.co.uk>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
Date: Tue, 29 Jan 2013 17:56:46 -0600
Subject: RE: [Q]staging/comedi: Considation of *_find_boardinfo possible?
Thread-Topic: [Q]staging/comedi: Considation of *_find_boardinfo possible?
Thread-Index: Ac3+ecuagVdYiWvDRZaVMd4lwt4pQQAAUCBw
Message-ID: <ADE657CA350FB648AAC2C43247A983F00207A707B3C8@AUSP01VMBX24.collaborationhost.net>
References: <201301300041.36064.PeterHuewe@gmx.de>
In-Reply-To: <201301300041.36064.PeterHuewe@gmx.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 29, 2013 4:42 PM, Peter Hüwe wrote:
> Hi,
>
> while analyzing the comedi drivers, I noticed that quite a lot of them use a 
> more or less similar find_boardinfo function.

<snip>

> The names and the exact implementation differ slightly, but in most cases it 
> boils down to:
>	unsigned int i;
>
>	for (i = 0; i < ARRAY_SIZE(__BOARD_ARRAY__); i++)
>		if (pcidev->device == __BOARD_ARRAY__[i].device_id)
>			return &__BOARD_ARRAY__[i];
>	return NULL;
>
> unfortunately the __BOARD_ARRAY__ is always of a different type (but all 
> contain the device_id field) and size.
>
>
> ---> is there a way to consolidate these functions into one function (which 
> can operate on the different types) ?  It's almost a bit like 'templates'.
> Maybe with some gcc extensions or kernel magic functions ?
>
> I already thought about passing a void pointer to the __BOARD_ARRAY__ and the 
> size of one element of the __BOARD_ARRAY__ and doing pointer calculations - 
> but I guess there must be a better way.
>
> Or is the only option to write a macro ?

As you noticed, the problem is the driver specific definition of the struct used
to hold the boardinfo.

In drivers.c, the comedi_recognize() function actually access the boardinfo
in order to support the COMEDI_DEVCONFIG ioctl. There is a comment above
it giving a description of how it works.

There might be a way to do this in a generic way. The problem is that the
drivers use different names for "common" information and the data is
packed in the structs differently so accessing it generically is a bit difficult,
if not impossible.

I have been trying to remove as much of this boardinfo stuff from the drivers
as possible. For now I think the current implementation is fairly clean.

For the PnP bus drivers that use the auto_attach mechanism I have some ideas
to get rid of the find_boardinfo functions but I need to work out the kinks first.

Please wait on "fixing" any of this until a good solution is worked out.

Thanks,
Hartley

