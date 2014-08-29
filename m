Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591AbaH2Ba5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 21:30:57 -0400
Received: from mga11.intel.com ([192.55.52.93]:63879 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506AbaH2Ba4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 21:30:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,421,1406617200"; 
   d="scan'208";a="583195232"
Message-ID: <53FFD7CE.5050000@linux.intel.com>
Date: Fri, 29 Aug 2014 09:30:54 +0800
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>, Chen LinX <linx.z.chen@intel.com>
CC: linux-kernel@vger.kernel.org, "He, Bo" <bo.he@intel.com>
Subject: Re: [PATCH] debugfs: keep the old valid mode value when no explicity
 specify it
References: <1409220549-15485-1-git-send-email-linx.z.chen@intel.com> <20140828151020.GA17945@kroah.com>
In-Reply-To: <20140828151020.GA17945@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/8/28 23:10, Greg KH wrote:

> On Thu, Aug 28, 2014 at 06:09:09PM +0800, Chen LinX wrote:
>> From: "Chen, LinX" <linx.z.chen@intel.com>
>>
>> When mount debugfs with no mode specifed after it's mounted, the mount
>> point mode will change to default mode(0700) even the mount operation was fail,
>> this will cause some issues like can't get binder info in android.
> I don't understand, what did you do to get into this state?

Greg,

Thanks for your kind quick comments. The patch description can be improved.

We hit the issue when debugging a UIWDT issue. Android framework has a good
method to detect userspace hang and reports UIWDT issues. Android uses
client/server model. Clients communicates with servers by binder. binder has
debugfs interfaces. Some files show what threads are communicating with what
other threads. If one thread is blocked for a long time, we can find the
blocking chain from the binder info.

Since the error dumping process has no root access, booting process changes
debugfs mount dir mode to 0755. When UIWDT happens, the error dumping
process can read the info.

Unfortunately, some other scripts at booting try to mount debugfs for many times.
No matter if the double mounting fails or succeeds, debugfs_parse_options changes
the root inode's mode back to the default 0700. It means the effect of previous
mode changing to 0755 is lost. At UIWDT, the dumping process can't save binder
info to disk log files.

>
> And why does binder care about debugfs?
>
>> Here we can keep the old valid mode if no explicity specify the mode
>> value and also change the mode value even the mount fails if the mode
>> value is specified.
> I can't parse this sentence :(

Lin's patch checks if debugfs_mount_opts->mode is initiated.
If it is already, the patch would bypass the reinitiation, so the old mode
value is kept.

Yanmin

