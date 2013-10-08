Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635Ab3JHAJU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 20:09:20 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:37691 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751615Ab3JHAJT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 20:09:19 -0400
MIME-Version: 1.0
In-Reply-To: <1381185204.2081.221.camel@joe-AO722>
References: <1381184340-11190-1-git-send-email-geyslan@gmail.com>
	<1381185204.2081.221.camel@joe-AO722>
Date: Mon, 7 Oct 2013 21:09:18 -0300
Message-ID: <CAGG-pURYyCV4waC8Z+5qAd1mAB2ZHhEkRaGspFuyEDrvj_dTdQ@mail.gmail.com>
Subject: Re: [PATCH] 9p: unsigned/signed wrap in p9/unix modes.
From: =?UTF-8?Q?Geyslan_Greg=C3=B3rio_Bem?= <geyslan@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Eric Van Hensbergen <ericvh@gmail.com>, rminnich@sandia.gov,
        lucho@ionkov.net, v9fs-developer@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, kernel-br <kernel-br@googlegroups.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe,

Thank you for reply.

What do you think about:

                 strncpy(ext, stat->extension, sizeof(ext));
+                 if (sscanf(ext, "%c %u %u", &type, &major, &minor) < 3) {
+                                  p9_debug(P9_DEBUG_ERROR,
+                                  "It's necessary define type, major
and minor values when using P9_DMDEVICE");
+                                  return res;
+                 }
                 switch (type) {
                 case 'c':
                         res |= S_IFCHR;
                         break;
...
                 *rdev = MKDEV(major, minor);

Geyslan Gregório Bem
hackingbits.com


2013/10/7 Joe Perches <joe@perches.com>:
> On Mon, 2013-10-07 at 19:19 -0300, Geyslan G. Bem wrote:
>> Changes the sign type to unsigned, avoiding the possibility of
>> wrap when ORing the p9 or unix bit modes.
> []
>> diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
> []
>> @@ -144,7 +144,7 @@ static umode_t p9mode2unixmode(struct v9fs_session_info *v9ses,
>>       else if ((mode & P9_DMDEVICE) && (v9fs_proto_dotu(v9ses))
>>                && (v9ses->nodev == 0)) {
>>               char type = 0, ext[32];
>> -             int major = -1, minor = -1;
>> +             u32 major = 0, minor = 0;
>>
>>               strlcpy(ext, stat->extension, sizeof(ext));
>>               sscanf(ext, "%c %u %u", &type, &major, &minor);
>
> This bit changes the MKDEV below it.
>
> I would think that the sscanf return should be
> checked for 3 and maybe MKDEV should not be
> constructed when it's not.
>
>
