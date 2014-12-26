Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521AbaLZT0i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 14:26:38 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:18433 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751127AbaLZT0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 14:26:36 -0500
Message-ID: <549DB660.8040606@fb.com>
Date: Fri, 26 Dec 2014 14:26:24 -0500
From: Alex Gartrell <agartrell@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Jason Wang <jasowang@redhat.com>, <davem@davemloft.net>,
        <herbert@gondor.apana.org.au>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: Re: [PATCH net-next 1/2] socket: Allow external sockets to use socket
 syscalls
References: <1419576624-8999-1-git-send-email-agartrell@fb.com> <1419576624-8999-2-git-send-email-agartrell@fb.com> <549D2E51.3040200@redhat.com>
In-Reply-To: <549D2E51.3040200@redhat.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-26_07:2014-12-24,2014-12-26,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=0
 compositescore=0.919135270856499 urlsuspect_oldscore=0.919135270856499
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.919135270856499 spamscore=0
 recipient_to_sender_domain_totalscore=1 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1412260210
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jason,

Thanks again for your comments.

On 12/26/14 4:45 AM, Jason Wang wrote:
>> @@ -388,6 +388,7 @@ struct file *sock_alloc_file(struct socket *sock, int flags, const char *dname)
>>   	sock->file = file;
>>   	file->f_flags = O_RDWR | (flags & O_NONBLOCK);
>>   	file->private_data = sock;
>> +	file->private_data_is_socket = true;
>
> This is only safe if all user of sock_alloc_file() have full support for
> each method in proto_ops.

This doesn't change anything in the invocation of the syscalls, as every 
file allocated through this path already passes the "is_socket" test due 
to the (sadly missing here)
     file = alloc_file(..., &socket_file_ops)
above, so this makes things no less safe than they were.

Of course we also need to implement these proto_ops for the tun device 
in the subsequent patch to make it work.

>>   	return file;
>>   }
>>   EXPORT_SYMBOL(sock_alloc_file);
>> @@ -411,7 +412,7 @@ static int sock_map_fd(struct socket *sock, int flags)
>>
>>   struct socket *sock_from_file(struct file *file, int *err)
>>   {
>> -	if (file->f_op == &socket_file_ops)
>> +	if (file->private_data_is_socket)
>>   		return file->private_data;	/* set in sock_map_fd */
>>
>>   	*err = -ENOTSOCK;
>
> Not sure it's the best method, how about a dedicated f_op to do this?

So like a get_socket operation?  That would simplify this a lot, 
certainly (we wouldn't need to move private_data around in the tun driver).

Thanks,
-- 
Alex Gartrell <agartrell@fb.com>


