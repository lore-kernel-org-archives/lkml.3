Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762523Ab3JQS14 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 14:27:56 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:57181 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758770Ab3JQS1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 14:27:54 -0400
MIME-Version: 1.0
In-Reply-To: <20131017124515.3566d7c1@plati.site>
References: <CAH2r5muRfQ6y1vzu_1icz4BGTqEPfgaOsHExbQay_yZiCOZQ_A@mail.gmail.com>
	<20131017124515.3566d7c1@plati.site>
Date: Thu, 17 Oct 2013 13:27:52 -0500
Message-ID: <CADT32eJHi--oChq5TJLjv5GsVYAOGdnpY_=nxTBE10dKasr8Hg@mail.gmail.com>
Subject: Re: cp --reflink and target file open flags
From: Shirish Pargaonkar <shirishpargaonkar@gmail.com>
To: David Disseldorp <ddiss@suse.de>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think it would not matter which ioctl is used if the target file is
not opened with flag O_RDWR.

Perhaps cifs.ko can make the decision to change O_WRONLY
to O_RDWR based on the flag and location of the source and
destination files.


On Thu, Oct 17, 2013 at 5:45 AM, David Disseldorp <ddiss@suse.de> wrote:
> On Wed, 16 Oct 2013 18:36:19 -0500
> Steve French <smfrench@gmail.com> wrote:
>
>> cp --reflink opens the target file for O_WRONLY before invoking the
>> (BTRFS) ioctl for clone file, but for copy offload over the network
>> the SMB2 specification requires that the target file be open O_RDWR.
>>
>> I may be able to upgrade the target file handle on the fly by
>> reopening it in cifs.ko, and of course I can write an SMB2/SMB3
>> specific copy command, but it would be preferable to allow use of cp
>> --reflink since so many people are familiar with it.
>>
>> There is quite a bit of flexibility in server side copy offload  -
>> more than cp an offer, especially when using SMB3 or later dialects
>> (e.g. in number of chunks sent at one time, chunk size, attributes
>> copied, and even whether to use T10 style offload), but still it would
>> be nice to support "cp --reflink" over the network.  Any ideas on
>> this?
>>
>> After looking at copy.c in coreutils for cp - I couldn't think of any
>> trivial way to force cp to open the target RW.
>>
>> Ideas?
>
> You should be able to avoid this by using FSCTL_SRV_COPYCHUNK_WRITE
> instead of FSCTL_SRV_COPYCHUNK on the wire. The former doesn't require
> read access on the target, while the latter does. See [MS-SMB2] 2.2.31
> and smbtorture's copy_chunk_bad_access test.
>
> Samba only supported FSCTL_SRV_COPYCHUNK until now, as that's what
> Windows Server 2k12 uses for copies initiated by Explorer. I've just
> sent out the trivial patches adding FSCTL_SRV_COPYCHUNK_WRITE support.
>
> Cheers, David
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
