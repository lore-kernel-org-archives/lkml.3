Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647AbaD3Dbb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 23:31:31 -0400
Received: from linuxhacker.ru ([217.76.32.60]:43863 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751678AbaD3Dba convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 23:31:30 -0400
Subject: Re: [PATCH 18/47] staging/lustre/hsm: HSM requests not delivered
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Oleg Drokin <green@linuxhacker.ru>
In-Reply-To: <20140429090810.GY26890@mwanda>
Date: Tue, 29 Apr 2014 23:31:13 -0400
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        James Nunez <james.a.nunez@intel.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <34EC51E0-6759-40B6-A3E5-02871FD32979@linuxhacker.ru>
References: <1398618431-29757-1-git-send-email-green@linuxhacker.ru> <1398618431-29757-19-git-send-email-green@linuxhacker.ru> <20140429090810.GY26890@mwanda>
To: Dan Carpenter <dan.carpenter@oracle.com>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 29, 2014, at 5:08 AM, Dan Carpenter wrote:

> On Sun, Apr 27, 2014 at 01:06:42PM -0400, Oleg Drokin wrote:
>> diff --git a/drivers/staging/lustre/lustre/llite/dir.c b/drivers/staging/lustre/lustre/llite/dir.c
>> index 7fbc18e..c391b60 100644
>> --- a/drivers/staging/lustre/lustre/llite/dir.c
>> +++ b/drivers/staging/lustre/lustre/llite/dir.c
>> @@ -1804,6 +1804,11 @@ out_rmdir:
>> 		/* Compute the whole struct size */
>> 		totalsize = hur_len(hur);
> hur_len() has an integer overflow bug.

Indeed. Thanks.

The below check for the MDS_MAXREQSIZE was aimed at fixing it, I guess. But it's obviously flawed.

>> 		OBD_FREE_PTR(hur);
>> +
>> +		/* Final size will be more than double totalsize */
>> +		if (totalsize >= MDS_MAXREQSIZE / 3)
>> +			return -E2BIG;
> "totalsize" is signed and this condition doesn't take negatives into
> consideration.  Make totalsize unsigned.

In fact we should just enforce a max limit on item count in hur structure above
and that would take care of both the overflow and here.

>> +
>> 		OBD_ALLOC_LARGE(hur, totalsize);
> How do we know that "totalsize" is more than sizeof(*hur)?  If we fixed
> the overflow bug then maybe this isn't a problem.  I haven't looked.

hur_size calculates total size as size of the struct hur (but using offset_of of it's last member that's a zero-sized array + whatever the size of the follow on items.

Bye,
    Oleg