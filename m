Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304AbaJHKKB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 06:10:01 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:11119 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754434AbaJHKJ7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 06:09:59 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-9d-54350d74a8b9
From: Krzysztof Opasiak <k.opasiak@samsung.com>
To: "'Michal Nazarewicz'" <mina86@mina86.com>,
        "'Alan Stern'" <stern@rowland.harvard.edu>,
        "'Felipe Balbi'" <balbi@ti.com>
Cc: Robert Baldyga <r.baldyga@samsung.com>, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Karol Lewandowski <k.lewandowsk@samsung.com>,
        Stanislaw Wadas <s.wadas@samsung.com>
References: <Pine.LNX.4.44L0.1410071429500.1504-100000@iolanthe.rowland.org>
 <xa1toatny765.fsf@mina86.com>
In-reply-to: <xa1toatny765.fsf@mina86.com>
Subject: RE: [PATCH] usb: gadget: f_fs: add "zombie" mode
Date: Wed, 08 Oct 2014 12:09:55 +0200
Message-id: <0ab101cfe2e0$030e6360$092b2a20$%opasiak@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac/ianXuxv+NhWJGQu+AIG0e1BLC3wAcYnbQ
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsVy+t/xa7qlvKYhBhuNLGa9bGexOHi/3qJ5
	8Xo2i8ZPc5ktLu+aw2axaFkrs8WC4y2sFg8O72S3WHZjE5PFhN8X2By4PPbPXcPuse7PKyaP
	2Xd/MHr0bVnF6HH8xnYmj8+b5ALYorhsUlJzMstSi/TtErgyenZfYCvYK1LReXoPewPjPoEu
	Rk4OCQETiTWn97ND2GISF+6tZ+ti5OIQEljKKDH/4WkmCKeBSaKrfRZQFQcHm4C+xLxdoiCm
	iECZxNWbESAlzALdTBILV55nBRkkJJAjsWfjCyYQm1NAS+LIpgYWEFtYwFLi+5LzbCA2i4Cq
	RPffJ2BxXgFHibsbZjJB2IISPybfYwGZzyygLjFlSi5ImFlAW+LJuwusIGEJoPCjv7ogYREB
	I4nTjzqZIEpEJO42PGedwCg0C8mgWQiDZiEZNAtJxwJGllWMoqmlyQXFSem5hnrFibnFpXnp
	esn5uZsYIbH0ZQfj4mNWhxgFOBiVeHgNmk1ChFgTy4orcw8xSnAwK4nwVv8CCvGmJFZWpRbl
	xxeV5qQWH2Jk4uCUamB0YBCZ5FfKIGd76fzX6enX61bppWT4X/2RluJQKGu7oc53qr0YC3PV
	Wzcl71Uec9j6ONul779puhPbYsWtNLPs7e/jGz5sTkyaNuttr8xvGw+fN7s+Xl5TWdb3cW7Z
	m5msH96cPCfakTT/ttVn7QXTwv3tL8zznF+7K6E+2jCsbMuhxZ818o4psRRnJBpqMRcVJwIA
	TXjPUIMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> -----Original Message-----
> From: Mike Nazarewicz [mailto:mpn@google.com] On Behalf Of Michal
> Nazarewicz
> Sent: Tuesday, October 07, 2014 10:08 PM
> To: Alan Stern; Felipe Balbi
> Cc: Krzysztof Opasiak; 'Robert Baldyga';
> gregkh@linuxfoundation.org; linux-usb@vger.kernel.org; linux-
> kernel@vger.kernel.org; andrzej.p@samsung.com
> Subject: Re: [PATCH] usb: gadget: f_fs: add "zombie" mode
> 
> > On Tue, 7 Oct 2014, Felipe Balbi wrote:
> >> Right, but if we allow this, I can already see folks abusing to
> >> connect to the host early and only when necessary do some
> trickery to
> >> e.g. start adbd (not saying Android will do this, just using it
> as an
> >> easy example).
> 
> I don't really see that happening.  For the gadget to start all
> descriptors need to be known.  Functionfs  will know the
> descriptors
> only once the user space daemon provides them.  Therefore, with the
> current features (or even with addition of Robert's feature) there
> is no
> way to let the gadget start without having the daemon running.

Well, to be honest we do some lazy daemon startup in gadgetd. The idea is to provide functionality quite similar to inet. So we have divided functionfs services into two parts:
- Descriptors - provided in configuration file
- function implementation - provided in binary

Now user can create ffs function using gadgetd without worrying about mounting the file system, running daemon and many other stuff. Gadgetd is system-wide usb gadget manager which provides abstraction layer for kernel functions and ffs-based functions.

Example:
User would like to create gadget which contains MTP in first configuration and ADB in second. When gadgetd receives such request via DBUS it creates suitable functions on configfs, find suitable configuration files, mount two instances of ffs, write descriptors from config files and run poll() on both ep0. Please notice here that any other daemon has not been run but the whole gadget can be bound to UDC.

When usb device is connected to host then host will select one of available configurations. All functions in that configuration receive ENABLE event. When gadgetd receives such event from one of ep0 then fork() is executed and desired service is being run with all file descriptors opened and ready to use. Please also notice here that if  host select first configuration, only one of those daemon is going to be run.

(...)

-- 
Krzysztof Opasiak
Samsung R&D Institute Poland
Samsung Electronics
k.opasiak@samsung.com




