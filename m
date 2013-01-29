Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519Ab3A2XiG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 18:38:06 -0500
Received: from mout.gmx.net ([212.227.15.19]:54181 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067Ab3A2XiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 18:38:05 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19um90pgUBuq7J5cViISXkwV2PZTk6HktNxIqAWS+
	gKpuL++WhCDoz0
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Ian Abbott <abbotti@mev.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [Q]staging/comedi: Considation of *_find_boardinfo possible?
Date: Wed, 30 Jan 2013 00:41:35 +0100
User-Agent: KMail/1.13.7 (Linux/3.7.4; KDE/4.9.3; x86_64; ; )
Cc: ian Abbott <ian.abbott@mev.co.uk>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201301300041.36064.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

while analyzing the comedi drivers, I noticed that quite a lot of them use a 
more or less similar find_boardinfo function.
e.g.: 
cb_pcidas64.c 

static const struct pcidas64_board
*cb_pcidas64_find_pci_board(struct pci_dev *pcidev)
{
	unsigned int i;

	for (i = 0; i < ARRAY_SIZE(pcidas64_boards); i++)
		if (pcidev->device == pcidas64_boards[i].device_id)
			return &pcidas64_boards[i];
	return NULL;
}

and ni_6527.c:
static const struct ni6527_board *
ni6527_find_boardinfo(struct pci_dev *pcidev)
{
	unsigned int dev_id = pcidev->device;
	unsigned int n;

	for (n = 0; n < ARRAY_SIZE(ni6527_boards); n++) {
		const struct ni6527_board *board = &ni6527_boards[n];
		if (board->dev_id == dev_id)
			return board;
	}
	return NULL;
}




The names and the exact implementation differ slightly, but in most cases it 
boils down to:
	unsigned int i;

	for (i = 0; i < ARRAY_SIZE(__BOARD_ARRAY__); i++)
		if (pcidev->device == __BOARD_ARRAY__[i].device_id)
			return &__BOARD_ARRAY__[i];
	return NULL;

unfortunately the __BOARD_ARRAY__ is always of a different type (but all 
contain the device_id field) and size.


---> is there a way to consolidate these functions into one function (which 
can operate on the different types) ?  It's almost a bit like 'templates'.
Maybe with some gcc extensions or kernel magic functions ?

I already thought about passing a void pointer to the __BOARD_ARRAY__ and the 
size of one element of the __BOARD_ARRAY__ and doing pointer calculations - 
but I guess there must be a better way.

Or is the only option to write a macro ?


Looking forward to your replies.

Thanks,
Peter


