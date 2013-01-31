Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973Ab3AaWUH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 17:20:07 -0500
Received: from mail-vc0-f172.google.com ([209.85.220.172]:34515 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754325Ab3AaWUF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 17:20:05 -0500
MIME-Version: 1.0
Date: Thu, 31 Jan 2013 17:20:03 -0500
Message-ID: <CA+3xLx6HRWuc58oWP=T1J9NkKx958DQEULy+gMt8mooj3nsw+g@mail.gmail.com>
Subject: ABI violations eventually caused by short sighted coding style
From: Jon Pry <jonpry@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have recently been bitten by an ABI change. I'd prefer not to name names, but
it seems at this point the ABI cannot even be reverted. This sequence of events
results from the following strategy to deal with ioctl's using structures and
attempting to maintain backward compatibility.

Take for example the following:

foo_ioctl(struct *myioctldata);

The creator of this structure knows that the driver may have it's features
extended in the future. So they invent this:

struct foodata{
	u32 foo;
};

struct myioctldata{
	u32 type;
	union {
		struct foodata;
		u8 data[64];
	} u;
};


The creator is proud. Because now this ioctl is future proof. More structures
can simply be added in the future without breaking existing code. Right? Wrong.
If a new structure is added to the union that requires higher alignment. Like
adding a 64-bit element. The union will now be moved in the structure and
sizeof(myioctldata) will now be different to accommodate the padding.

This is even cooler if myioctldata.type is a u8, then it is possible to get 4
whole different sized structs depending on the contents of the union. I find
this to be rather stupid. The kernel is littered with this stuff so it's
probably impossible to remove it. At least new code should not be encouraged to
follow this form. Most developers just don't know and assume if the struct is
small enough, it will not cause any problems. To make matters worse,
the effects
can be different on 32/64bit platforms, allowing the code to pass testing.

I believe changes should be made to the coding style forcing developers to take
action. There are a couple of solutions I can think of:

1. 	Put the unions at the beginning of structures if possible, or at least put
	them in a position that would ensure 8 byte offset from the beginning of
	the struct. Such as after a u64. Multiple unions should ensure the data[]
	of the preceding unions to be a multiple of 8 bytes.
2.  Require the data element to be declared as u64[size/8].
3.  Pack the ioctl structures

My preference is for the former since it does not cause any
unnecessary padding.

Regards,

Jon Pry
