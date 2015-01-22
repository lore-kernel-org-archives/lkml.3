Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534AbbAVVdR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 16:33:17 -0500
Received: from mailout.micron.com ([137.201.242.129]:18301 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147AbbAVVdO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 16:33:14 -0500
From: "Andy Falanga (afalanga)" <afalanga@micron.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: block layer copying user io vectors
Thread-Topic: block layer copying user io vectors
Thread-Index: AdA2iwNUx2WCsO7EQqKFFQcSlbhWiw==
Date: Thu, 22 Jan 2015 21:33:08 +0000
Message-ID: <60F6FAE47D1BCE4380CC06D18F49789B952F7ED3@NTXBOIMBX02.micron.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [137.201.88.182]
x-tm-as-product-ver: SMEX-10.0.0.4152-7.000.1014-21274.002
x-tm-as-result: No--42.050900-0.000000-31
x-tm-as-user-approved-sender: Yes
x-tm-as-user-blocked-sender: No
x-mt-checkinternalsenderrule: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please CC me directly.

I am working in kernel 2.6.32 (CentOS 6).  To increase the upper limit
of sg from 4mb to at least 128mb in a single SCSI command.  At first I
thought this issue was in sg, but have tracked the issue to the block
layer.

Thinking I could solve this issue by using scatter/gather lists, I
increased the size from 32k to 4mb of each vector.  This did work
until I tried to send 8mb.  When I do so, I get errno EINVAL.  After
some tracing, I tracked the problem into bio_copy_user_iov().

This function does something that seems rather strange.  On line 859,
a for loop determines the number of pages needed for the copying of the
user data to kernel space.  Then the memory is allocated (line
886 bio_kmalloc()).  Then, strangely, on line 895, there is this
conditional:

if (map_data) {
    nr_pages = 1 << map_data->page_order;
    i = map_data->offset / PAGE_SIZE;
}

This effectively ignores the number of pages counted earlier (in this
case which applies to me), and then apparently disregards whatever
memory may have been allocated earlier.  Thinking that this was the
root I tried to correct this by commenting that simple branch from
bio_copy_user_iov, but still had the same result.  Can someone
help me understand what is happening in the block layer?

Thanks
