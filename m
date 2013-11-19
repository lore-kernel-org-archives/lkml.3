Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753080Ab3KSVXJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 16:23:09 -0500
Received: from mms3.broadcom.com ([216.31.210.19]:2207 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753026Ab3KSVXG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 16:23:06 -0500
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
From: "Charley (Hao Chuan) Chu" <charley.chu@broadcom.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Al Viro" <viro@zeniv.linux.org.uk>
cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] FS: Fixed buffer overflow issue in seq_read()
Thread-Topic: [PATCH] FS: Fixed buffer overflow issue in seq_read()
Thread-Index: Ac7krU8d+bL/VNzpTjKZYSvDtLeq/QAW0/eAAAPz8AAAFThi0A==
Date: Tue, 19 Nov 2013 21:22:58 +0000
Message-ID: <FB8A4655DFD2B34DB16AE06DDDD6C0E21BDBB7CD@SJEXCHMB12.corp.ad.broadcom.com>
References: <FB8A4655DFD2B34DB16AE06DDDD6C0E21BDB93D2@SJEXCHMB12.corp.ad.broadcom.com>
 <20131119012042.GA10323@ZenIV.linux.org.uk>
 <alpine.LFD.2.10.1311181912090.7995@i7.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.10.1311181912090.7995@i7.linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.16.203.100]
MIME-Version: 1.0
X-WSS-ID: 7E9509F71SC9418826-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> m->from is a red herring - it's not even looked at if m->count is 0.  

Then, shall the initialization here be removed too?

@@ -90,7 +90,7 @@ static int traverse(struct seq_file *m, loff_t offset)
 
        m->version = 0;
        index = 0;
-       m->count = m->from = 0;
+       m->count = 0;
        if (!offset) {
                m->index = index;
                return 0;

> What do you think about then just abstracing out that now common sequence 
> of re-allocating a larger buffer, while clearing m->count?

Following code is duplicated (slightly different) in both seq_read() and seq_lseek().
It would be nice to have them consolidated in traverse().

                while ((err = traverse(m, *ppos)) == -EAGAIN)
                        ;   
                if (err) {
                        /* With prejudice... */
                        m->read_pos = 0;
                        m->version = 0;
                        m->index = 0;
                        m->count = 0;
                        goto Done;
                } else {
                        m->read_pos = *ppos;
                }   

Thanks,
Charley

