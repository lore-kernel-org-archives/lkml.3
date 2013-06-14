Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759345Ab3FNB04 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 21:26:56 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:56055 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269Ab3FNB0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 21:26:55 -0400
Date: Fri, 14 Jun 2013 09:26:49 +0800
From: majianpeng <majianpeng@gmail.com>
To: john <john@johnmccutchan.com>, rlove <rlove@rlove.org>,
        eparis <eparis@parisplace.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Reply-To: majianpeng <majianpeng@gmail.com>
Subject: [BUG] Using inotify on /proc/partitoins
X-Priority: 3
X-GUID: 24782999-591C-49BB-BBDE-F9E3D6391FA7
X-Has-Attach: no
X-Mailer: Foxmail 7.0.1.90[en]
Mime-Version: 1.0
Message-ID: <201306140926455537935@gmail.com>
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r5E1RJj8001442

Hi all,
     I wanted to monitor /proc/partitions using inotify.Although now i know it can't catch the event of write.
But for read,it can't catch. The code is:
int main()
{
	int fd = inotify_init();
	int wd;
	char buff[4096];
	int ret;
	if (fd < 0)
		perror("inotify_init error\n");

	wd = inotify_add_watch(fd, "/proc/partitions", IN_ACCESS);
	if (wd < 0)
		perror("inotify_add_watch error\n");

	
	ret = read(fd, buff, 4096);
	if (ret < 0)
		perror("read error\n");
	else
		printf("buff %s\n", buff);
	return 0;
}

But when i call 'cat /proc/partitions',the program can't return.
So i added some message in kernel in order to find the reason.
In procfs for some files, the inode used this method to alloc.
proc_lookup-->proc_lookup_de--->proc_get_inode-->new_inode_pseudo
In new_inode_pseudo, it will alloc new inode so every open-operation procfs will alloc new inode.
So inotify can't work.

I think it should add a flag which indicate file can't support inotify.Although  there are a few files in procfs.


Thanks!
Jianpeng
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
