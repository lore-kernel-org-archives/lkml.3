Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847AbaGKH2A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 03:28:00 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:54438 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751119AbaGKH17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 03:27:59 -0400
X-IronPort-AV: E=Sophos;i="5.00,873,1396972800"; 
   d="scan'208";a="33141842"
From: "chenhanxiao@cn.fujitsu.com" <chenhanxiao@cn.fujitsu.com>
To: "Eric W. Biederman (ebiederm@xmission.com)" <ebiederm@xmission.com>,
        "Serge Hallyn (serge.hallyn@ubuntu.com)" <serge.hallyn@ubuntu.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
CC: "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "'Daniel P. Berrange (berrange@redhat.com)'" <berrange@redhat.com>
Subject: Could not mount sysfs when enable userns but disable netns
Thread-Topic: Could not mount sysfs when enable userns but disable netns
Thread-Index: Ac+c2DRilJPdRr/NSgeEExdq6ZiUQw==
Date: Fri, 11 Jul 2014 07:27:53 +0000
Message-ID: <5871495633F38949900D2BF2DC04883E562293@G08CNEXMBPEKD02.g08.fujitsu.local>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.167.226.240]
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s6B7SDZW016690

Hello,

How to reproduce:
1. Prepare a container, enable userns and disable netns
2. use libvirt-lxc to start a container
3. libvirt could not mount sysfs then failed to start.

Then I found that
commit 7dc5dbc879bd0779924b5132a48b731a0bc04a1e says:
"Don't allow mounting sysfs unless the caller has CAP_SYS_ADMIN rights
over the net namespace."

But why should we check sysfs mouont permission over net namespace?
We've already checked CAP_SYS_ADMIN though.

What the relationship between sysfs and net namespace,
or this check is a little redundant?

Any insights on this?

Thanks,
- Chen

PS: codes below could be a workaround

@@ -34,7 +35,8 @@ static struct dentry *sysfs_mount(struct file_system_type *fs_type,
                if (!capable(CAP_SYS_ADMIN) && !fs_fully_visible(fs_type))
                        return ERR_PTR(-EPERM);
 
-               if (!kobj_ns_current_may_mount(KOBJ_NS_TYPE_NET))
+               if (current->nsproxy->net_ns != &init_net &&
+                    !kobj_ns_current_may_mount(KOBJ_NS_TYPE_NET))
                        return ERR_PTR(-EPERM);
        }
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
