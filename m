Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490AbaGPEGz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 00:06:55 -0400
Received: from mail-qg0-f46.google.com ([209.85.192.46]:43431 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbaGPEGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 00:06:53 -0400
MIME-Version: 1.0
In-Reply-To: <CAH2r5muwjdPopeGCOi8a7OxAm=8cFsFKsEBywz5N1NQWotni6Q@mail.gmail.com>
References: <CAH2r5muwjdPopeGCOi8a7OxAm=8cFsFKsEBywz5N1NQWotni6Q@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Tue, 15 Jul 2014 23:06:32 -0500
Message-ID: <CAH2r5mtW+f0OeT-3ZJHMwU16_X0zip1Bf6bPZpsQRhzPS1aXDQ@mail.gmail.com>
Subject: Re: Additional performance data on Pavel's smb3 multi credit patch series
To: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Continuing testing of Pavel's newest SMB3 multicredit patch series,
which significantly improves large file read/write speeds to Samba and
Windows from Linux. For this workload LInux to Linux - SMB3 seems
faster than alternatives for read (copying from the server) but about
the same as NFS for write (copy to server).  Some additional data:

client Ubuntu with 3.16-rc4 and Pavel's patch series, server Fedora 20
(3.14.9 kernel, and Samba server version 4.1.9)

 dd if=/mnt/testfile of=/dev/null bs=50M count=30

testfile is 1.5GB existing file, unmount/mount inbetween each large
file copy to avoid any caching effect on client (although server will
have cached it)

SMB3 averaged 199MB/sec reads (copy from server)
CIFS averaged 170MB/sec reads (copy from server)
NFSv3 averaged 116MB/sec (copy from server)
NFSv4 and v4.1 averaged 110MB/sec (copy from server)

Write speeds (doing dd if=/dev/zero of=/mnt/testfile bs=60M count=25)
were more widely varied but averaged similar speeds for copy to server
for both NFSv3/v4/v4.1 and SMB3 (about 175MB/s)

On Sun, Jul 13, 2014 at 2:23 PM, Steve French <smfrench@gmail.com> wrote:
> Performance of Pavel's multicredit i/o SMB3 patches continues to look
> good.  Additional informal performance results below comparing cifs
> mounts with smb3 mounts (vers=3.0) with and without Pavel's patch set.
> I plan to do additional testing with large rsize/wsize (default with
> Pavel's code is 1MB).
>
> 3.16-rc4 (Ubuntu) on client.  Server is Windows 8.1.  Both VMs on same
> host (host disk is fairly fast SSD).
>
> Copy to server performance increased about 20% percent
> dd if=/dev/zero of=/mnt/targetfile bs=80M count=25
> got similar results with or without conv=fdatasync
>
> 1st run copying to empty directory, 2nd run copying over targetfile,
> (pattern repeated multiple times) averaging results
>
> New code (with Pavel's patches)
> ---------------------------------------------
> CIFS 167MB/s
> SMB3 200MB/s
>
> Existing code (without his patches)
> ------------------------------------------------
> SMB3 166MB/s
> CIFS 164.5MB/s
>
> For large file reading SMB3 performance with Pavel's patches increased
> 76% over existing SMB3 code
> dd of=/dev/null if=/mnt/targetfile bs=80M count=25
> (mounting and unmounting between attempts to avoid caching effects on
> the client)
>
> New code (with Pavel's patches)
> ---------------------------------------------
> CIFS 114MB/s
> SMB3 216MB/s
>
> Existing code (without his patches)
> ------------------------------------------------
> SMB3 123MB/s
> CIFS 110MB/s
>
> --
> Thanks,
>
> Steve



-- 
Thanks,

Steve
