Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751019AbaKURnu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 12:43:50 -0500
Received: from mx0.aculab.com ([213.249.233.131]:40525 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751055AbaKURns convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 12:43:48 -0500
From: David Laight <David.Laight@ACULAB.COM>
To: "'Al Viro'" <viro@ZenIV.linux.org.uk>,
        Eric Dumazet <eric.dumazet@gmail.com>
CC: David Miller <davem@davemloft.net>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: RE: [RFC] situation with csum_and_copy_... API
Thread-Topic: [RFC] situation with csum_and_copy_... API
Thread-Index: AQHQBWgr4bLXouueRUuDoiZfcNPHWpxrWCtw
Date: Fri, 21 Nov 2014 17:42:55 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1C9F6930@AcuExch.aculab.com>
References: <CA+55aFyQR2gOzEDROcWFcQzLvTjOxyJRjFJXJ03JB5knd-Gsgg@mail.gmail.com>
 <20141119.161744.1661940121298888832.davem@davemloft.net>
 <20141119213006.GE7996@ZenIV.linux.org.uk>
 <20141119.165340.2162829993279387495.davem@davemloft.net>
 <20141120214753.GR7996@ZenIV.linux.org.uk>
 <1416520542.8629.46.camel@edumazet-glaptop2.roam.corp.google.com>
 <20141120222506.GS7996@ZenIV.linux.org.uk>
 <1416524035.8629.54.camel@edumazet-glaptop2.roam.corp.google.com>
 <20141121084956.GT7996@ZenIV.linux.org.uk>
In-Reply-To: <20141121084956.GT7996@ZenIV.linux.org.uk>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro
...
> We would be better off with iov_iter passed to __sock_{send,recv}msg() (as
> a part of struct msghdr, instead of ->msg_iov/->msg_iovlen) and always
> advanced to match the amount of data actually picked from it.  With iovec
> behind it remaining constant.  That would work just as well as the current
> variant for sendmsg(2)/recvmsg(2)/etc., be a lot more convenient for
> kernel_{send,recv}msg() callers and would allow a lot of other fun stuff.

Callers of kernel_send/recvmsg() could easily be using a wrapper
function that creates the 'msghdr'.
When the want to send the remaining part of a buffer the old iterator
will no longer be available - just the original iov and the required offset.

So it would be useful if the iterator could be initialised to a byte
offset down the iov[].

Are there any current code paths where the iov[] is modified but
ends up being something other than 'the remaining data'?
If not then code can check whether iov[0].len has changed, and
skip the 'advance' is it has.

(I've an out-of-tree driver that assumes the iov[] isn't changed.)

	David



