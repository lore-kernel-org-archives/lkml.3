Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751544Ab3LKQnx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 11:43:53 -0500
Received: from mga11.intel.com ([192.55.52.93]:12755 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751262Ab3LKQno (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 11:43:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,872,1378882800"; 
   d="scan'208";a="448412652"
Date: Wed, 11 Dec 2013 11:43:42 -0500
From: Matthew Wilcox <willy@linux.intel.com>
To: Rajiv Shanmugam Madeswaran <smrajiv15@gmail.com>
Cc: linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] block: nvme-core: Scatter gather list support in the
 NVMe Block Driver
Message-ID: <20131211164342.GJ6900@linux.intel.com>
References: <1386778908-3370-1-git-send-email-smrajiv15@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386778908-3370-1-git-send-email-smrajiv15@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 09:51:48PM +0530, Rajiv Shanmugam Madeswaran wrote:
> Present nvme block driver supports PRP mode of data transfer for Admin
> and I/O commands. As per NVMe specification 1.1a I/O commands can also
> be transferred through SGL.

Yes, they *can*.  But why?  PRPs are more efficient for just about every
use case.

I'm not going to accept a patch which unconditionally uses SGLs.
I'm not convinced of the value of SGLs for Linux (apparently they're
useful for Windows).  I could be talked into a patch which conditionally
uses SGLs if they're more efficient for an individual command.

> @@ -59,6 +59,14 @@ static DEFINE_SPINLOCK(dev_list_lock);
>  static LIST_HEAD(dev_list);
>  static struct task_struct *nvme_thread;
>  
> +static struct nvme_iod*
> +	(*iodfp) (unsigned nseg, unsigned nbytes, gfp_t gfp);
> +
> +static int (*setup_xfer) (struct nvme_dev *dev, struct nvme_common_command *cmd,
> +				struct nvme_iod *iod, int total_len, gfp_t gfp);
> +
> +static void (*free_iod) (struct nvme_dev *dev, struct nvme_iod *iod);

So what happens if you have two controllers in your computer, one of
which supports SGLs and one of which doesn't?

> +struct sgl_desc {
> +	__le64 addr;
> +	__le32  length;
> +	__u8    rsvd[3];
> +	__u8    zero:4;
> +	__u8    sg_id:4;
> +};
> +
> +struct prp_list {
> +	__le64  prp1;
> +	__le64  prp2;
> +};
> +
> +union data_buffer {
> +	struct sgl_desc sgl;
> +	struct prp_list prp;
> +};
> +
>  struct nvme_common_command {
>  	__u8			opcode;
>  	__u8			flags;
> @@ -175,8 +202,7 @@ struct nvme_common_command {
>  	__le32			nsid;
>  	__le32			cdw2[2];
>  	__le64			metadata;
> -	__le64			prp1;
> -	__le64			prp2;
> +	union data_buffer	buffer;
>  	__le32			cdw10[6];
>  };

Probabaly better to use anonymous unions here:

-	__le64			prp1;
-	__le64			prp2;
+	union {
+		struct {
+			__le64	prp1;
+			__le64	prp2;
+		};
+		struct {
+			__le64	addr;
+			__le32  length;
+			__u8    rsvd[3];
+			__u8    sg_id;
+		};
+	};

Note that you shouldn't use bitfields.  The compiler does not necessarily
lay them out the way you expect it to.

